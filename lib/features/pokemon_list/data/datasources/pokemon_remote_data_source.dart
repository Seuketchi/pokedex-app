import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  /// Fetches a list of Pokémon from the API
  /// [limit] and [offset] allow pagination
  Future<List<PokemonModel>> getPokemonList({int limit = 20, int offset = 0});

  /// Searches for a specific Pokémon by name
  /// Returns a single Pokemon in a list if found
  Future<List<PokemonModel>> searchPokemon(String query);

  /// Fetches all Pokémon of a specific type
  /// [typeName] should be the lowercase type name (e.g., 'fire', 'water')
  Future<List<PokemonModel>> getPokemonByType(String typeName);
}
