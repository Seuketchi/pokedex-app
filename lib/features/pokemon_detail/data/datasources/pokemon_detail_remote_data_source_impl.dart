import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/network/network_info.dart';
import 'package:pokedex_app/features/pokemon_detail/data/datasources/pokemon_detail_api_service.dart';
import 'package:pokedex_app/features/pokemon_detail/data/datasources/pokemon_detail_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_detail_model.dart';

@Singleton(as: PokemonDetailRemoteDataSource)
class PokemonDetailRemoteDataSourceImpl
    implements PokemonDetailRemoteDataSource {
  PokemonDetailRemoteDataSourceImpl(this.apiService, this.networkInfo);

  final PokemonDetailApiService apiService;
  final NetworkInfo networkInfo;

  @override
  Future<PokemonDetailModel> getPokemonDetail(int id) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException(message: 'No internet connection');
    }

    try {
      return await apiService.getPokemonDetail(id);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch Pokémon detail',
      );
    }
  }

  @override
  Future<EvolutionChainModel> getEvolutionChain(int speciesId) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException(message: 'No internet connection');
    }

    try {
      final species = await apiService.getPokemonSpecies(speciesId);
      return await apiService.getEvolutionChain(species.evolutionChain.id);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch evolution chain',
      );
    }
  }
}
