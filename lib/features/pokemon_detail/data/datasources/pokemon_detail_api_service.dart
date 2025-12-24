import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_species_model.dart';
import 'package:retrofit/retrofit.dart';

part 'pokemon_detail_api_service.g.dart';

@RestApi(baseUrl: 'https://pokeapi.co/api/v2')
abstract class PokemonDetailApiService {
  @factoryMethod
  factory PokemonDetailApiService(Dio dio) = _PokemonDetailApiService;

  @GET('/pokemon/{id}')
  Future<PokemonDetailModel> getPokemonDetail(
    @Path('id') int id,
  );

  @GET('/pokemon-species/{id}')
  Future<PokemonSpeciesModel> getPokemonSpecies(
    @Path('id') int id,
  );

  @GET('/evolution-chain/{id}')
  Future<EvolutionChainModel> getEvolutionChain(
    @Path('id') int id,
  );
}
