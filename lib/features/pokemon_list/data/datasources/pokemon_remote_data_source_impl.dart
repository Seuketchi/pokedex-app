import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/pokemon_list/data/datasources/pokemon_api_service.dart';
import 'package:pokedex_app/features/pokemon_list/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/type_model.dart';

@Singleton(as: PokemonRemoteDataSource)
class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  PokemonRemoteDataSourceImpl(this.apiService, this.networkInfo);

  final PokemonApiService apiService;
  final NetworkInfo networkInfo;

  @override
  Future<List<PokemonModel>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      final response = await apiService.getPokemonList(limit, offset);
      return response.results;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch Pokémon list',
      );
    }
  }

  @override
  Future<List<PokemonModel>> getPokemonByType(String typeName) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      final response = await apiService.getPokemonByType(typeName);
      return response.pokemon.map((slot) => slot.pokemon).toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch Pokémon by type',
      );
    }
  }

  @override
  Future<List<PokemonModel>> searchPokemon(String query) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      final response = await apiService.searchPokemon(query.toLowerCase());
      return response.results;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ServerException(message: e.message ?? 'Failed to search Pokémon');
    }
  }

  @override
  Future<List<TypeModel>> getPokemonTypes() async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException();
    }
    try {
      final response = await apiService.getPokemonTypes();
      return response.results;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch Pokémon types',
      );
    }
  }
}
