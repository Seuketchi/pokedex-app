import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Result<List<Pokemon>, Failure>> getPokemonList({
    required int limit,
    required int offset,
  });

  Future<Result<List<Pokemon>, Failure>> searchPokemon(String query);

  Future<Result<List<Pokemon>, Failure>> filterByType(String type);
}
