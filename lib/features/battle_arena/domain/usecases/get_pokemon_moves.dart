import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';
import 'package:pokedex_app/features/battle_arena/domain/repositories/battle_repository.dart';

part 'get_pokemon_moves.freezed.dart';

@injectable
class GetPokemonMoves implements UseCase<List<Move>, PokemonMovesParams> {
  GetPokemonMoves(this.repository);

  final BattleRepository repository;

  @override
  Future<Result<List<Move>, Failure>> call(PokemonMovesParams params) async {
    return repository.getPokemonMoves(params.pokemonId);
  }
}

@freezed
class PokemonMovesParams with _$PokemonMovesParams {
  const factory PokemonMovesParams({required int pokemonId}) =
      _PokemonMovesParams;
}
