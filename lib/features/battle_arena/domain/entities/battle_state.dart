import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_log.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/battle_pokemon.dart';

part 'battle_state.freezed.dart';

@freezed
class BattleState with _$BattleState {
  const factory BattleState({
    required BattlePokemon playerPokemon,
    required BattlePokemon opponentPokemon,
    required bool isPlayerTurn,
    required List<BattleLog> battleLogs,
    BattlePokemon? winner,
  }) = _BattleState;
}
