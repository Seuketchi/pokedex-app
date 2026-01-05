import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_log.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_pokemon.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/calculate_damage.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/get_pokemon_moves.dart';
import 'package:pokedex_app/features/battle_arena/domain/usecases/get_type_effectiveness.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/usecases/get_pokemon_detail.dart';

part 'battle_bloc.freezed.dart';
part 'battle_event.dart';
part 'battle_state.dart';

@injectable
class BattleBloc extends Bloc<BattleEvent, BattleState> {
  BattleBloc(
    this.getPokemonDetail,
    this.getPokemonMoves,
    this.getTypeEffectiveness,
    this.calculateDamage,
  ) : super(const BattleState()) {
    on<_InitializeBattle>(_onInitializeBattle);
    on<_ExecuteMove>(_onExecuteMove);
    on<_Reset>(_onReset);
  }

  final GetPokemonDetail getPokemonDetail;
  final GetPokemonMoves getPokemonMoves;
  final GetTypeEffectiveness getTypeEffectiveness;
  final CalculateDamage calculateDamage;

  Future<void> _onInitializeBattle(
    _InitializeBattle event,
    Emitter<BattleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // PARALLEL FETCHING - All at once! ⚡
      final results = await Future.wait([
        getPokemonDetail(PokemonIdParams(id: event.playerPokemonId)),
        getPokemonDetail(PokemonIdParams(id: event.opponentPokemonId)),
        getPokemonMoves(PokemonMovesParams(pokemonId: event.playerPokemonId)),
        getPokemonMoves(PokemonMovesParams(pokemonId: event.opponentPokemonId)),
      ]);

      // Extract results
      PokemonDetail? playerDetail;
      PokemonDetail? opponentDetail;
      List<Move>? playerMoves;
      List<Move>? opponentMoves;
      String? errorMessage;

      // Check player detail
      results[0].when(
        (detail) => playerDetail = detail as PokemonDetail,
        failure: (failure) => errorMessage = failure.message,
      );
      if (errorMessage != null) {
        emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
        return;
      }

      // Check opponent detail
      results[1].when(
        (detail) => opponentDetail = detail as PokemonDetail,
        failure: (failure) => errorMessage = failure.message,
      );
      if (errorMessage != null) {
        emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
        return;
      }

      // Check player moves
      results[2].when(
        (moves) => playerMoves = moves as List<Move>,
        failure: (failure) => errorMessage = failure.message,
      );
      if (errorMessage != null) {
        emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
        return;
      }

      // Check opponent moves
      results[3].when(
        (moves) => opponentMoves = moves as List<Move>,
        failure: (failure) => errorMessage = failure.message,
      );
      if (errorMessage != null) {
        emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
        return;
      }

      // All data fetched successfully
      if (playerDetail == null ||
          opponentDetail == null ||
          playerMoves == null ||
          opponentMoves == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load Pokemon data',
          ),
        );
        return;
      }

      // Create BattlePokemon entities
      final playerBattlePokemon = _createBattlePokemon(
        playerDetail!,
        playerMoves!,
      );
      final opponentBattlePokemon = _createBattlePokemon(
        opponentDetail!,
        opponentMoves!,
      );

      // Determine who goes first based on speed
      final playerGoesFirst =
          playerBattlePokemon.speed >= opponentBattlePokemon.speed;

      emit(
        state.copyWith(
          isLoading: false,
          isInitialized: true,
          playerPokemon: playerBattlePokemon,
          opponentPokemon: opponentBattlePokemon,
          isPlayerTurn: playerGoesFirst,
          battleLogs: [
            BattleLog(
              message:
                  'Battle started! ${playerGoesFirst ? playerBattlePokemon.name : opponentBattlePokemon.name} goes first!',
              timestamp: DateTime.now(),
            ),
          ],
        ),
      );

      // NO AUTO-ATTACK - Wait for manual input!
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error: $e',
        ),
      );
    }
  }

  Future<void> _onExecuteMove(
    _ExecuteMove event,
    Emitter<BattleState> emit,
  ) async {
    if (state.isBattleOver || !state.isInitialized) return;

    final attacker = state.isPlayerTurn
        ? state.playerPokemon!
        : state.opponentPokemon!;
    final defender = state.isPlayerTurn
        ? state.opponentPokemon!
        : state.playerPokemon!;
    final move = event.move;

    final logs = List<BattleLog>.from(state.battleLogs);

    // Check accuracy
    final hitChance = Random().nextInt(100) + 1;
    if (hitChance > move.accuracy) {
      logs.add(
        BattleLog(
          message: '${attacker.name} used ${move.name} but it missed!',
          timestamp: DateTime.now(),
        ),
      );

      emit(
        state.copyWith(
          battleLogs: logs,
          isPlayerTurn: !state.isPlayerTurn,
        ),
      );

      // NO AUTO-ATTACK - Just switch turns
      return;
    }

    // Calculate type effectiveness
    final effectiveness = await _getTypeEffectivenessMultiplier(
      move.type,
      defender.types,
    );

    // Calculate damage
    final damageResult = await calculateDamage(
      CalculateDamageParams(
        attacker: attacker,
        defender: defender,
        move: move,
        typeEffectiveness: effectiveness,
      ),
    );

    late int damage;
    damageResult.when(
      (dmg) => damage = dmg,
      failure: (_) => damage = 0,
    );

    // Apply damage
    final newHp = (defender.currentHp - damage).clamp(0, defender.maxHp);
    final updatedDefender = defender.copyWith(currentHp: newHp);

    logs.add(
      BattleLog(
        message: '${attacker.name} used ${move.name}!',
        timestamp: DateTime.now(),
      ),
    );

    if (effectiveness > 1.0) {
      logs.add(
        BattleLog(
          message: "It's super effective!",
          timestamp: DateTime.now(),
        ),
      );
    } else if (effectiveness < 1.0 && effectiveness > 0.0) {
      logs.add(
        BattleLog(
          message: "It's not very effective...",
          timestamp: DateTime.now(),
        ),
      );
    } else if (effectiveness == 0.0) {
      logs.add(
        BattleLog(
          message: "It doesn't affect ${defender.name}...",
          timestamp: DateTime.now(),
        ),
      );
    }

    logs.add(
      BattleLog(
        message: '${defender.name} took $damage damage!',
        timestamp: DateTime.now(),
      ),
    );

    // Check for KO
    BattlePokemon? winner;
    var isBattleOver = false;

    if (newHp <= 0) {
      logs
        ..add(
          BattleLog(
            message: '${defender.name} fainted!',
            timestamp: DateTime.now(),
          ),
        )
        ..add(
          BattleLog(
            message: '${attacker.name} wins!',
            timestamp: DateTime.now(),
          ),
        );
      winner = attacker;
      isBattleOver = true;
    }

    // Update state
    final newState = state.copyWith(
      playerPokemon: state.isPlayerTurn ? state.playerPokemon : updatedDefender,
      opponentPokemon: state.isPlayerTurn
          ? updatedDefender
          : state.opponentPokemon,
      isPlayerTurn: !state.isPlayerTurn,
      battleLogs: logs,
      winner: winner,
      isBattleOver: isBattleOver,
    );

    emit(newState);
  }

  void _onReset(_Reset event, Emitter<BattleState> emit) {
    emit(const BattleState());
  }

  BattlePokemon _createBattlePokemon(
    PokemonDetail detail,
    List<Move> moves,
  ) {
    final hp = detail.stats.firstWhere((s) => s.name == 'hp').baseStat;
    final attack = detail.stats.firstWhere((s) => s.name == 'attack').baseStat;
    final defense = detail.stats
        .firstWhere((s) => s.name == 'defense')
        .baseStat;
    final speed = detail.stats.firstWhere((s) => s.name == 'speed').baseStat;

    return BattlePokemon(
      id: detail.id,
      name: detail.name,
      imageUrl: detail.sprites.frontDefault,
      types: detail.types.map((t) => t.name).toList(),
      maxHp: hp,
      currentHp: hp,
      attack: attack,
      defense: defense,
      speed: speed,
      moves: moves.take(4).toList(),
    );
  }

  Future<double> _getTypeEffectivenessMultiplier(
    String moveType,
    List<String> defenderTypes,
  ) async {
    var multiplier = 1.0;

    final result = await getTypeEffectiveness(
      TypeEffectivenessParams(typeName: moveType),
    );

    result.when(
      (effectiveness) {
        for (final defenderType in defenderTypes) {
          if (effectiveness.doubleDamageTo.contains(defenderType)) {
            multiplier *= 2.0;
          } else if (effectiveness.halfDamageTo.contains(defenderType)) {
            multiplier *= 0.5;
          } else if (effectiveness.noDamageTo.contains(defenderType)) {
            multiplier = 0.0;
          }
        }
      },
      failure: (_) {},
    );

    return multiplier;
  }
}
