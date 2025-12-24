import 'package:dio/dio.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_list_response.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_type_response.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/type_list_response.dart';
import 'package:retrofit/retrofit.dart';

part 'pokemon_api_service.g.dart';

@RestApi(baseUrl: "https://pokeapi.co/api/v2")
abstract class PokemonApiService {
  factory PokemonApiService(Dio dio, {String baseUrl}) = _PokemonApiService;

  @GET("/pokemon")
  Future<PokemonListResponse> getPokemonList(
    @Query("limit") int limit,
    @Query("offset") int offset,
  );

  @GET("/type/{typeName}")
  Future<PokemonTypeResponse> getPokemonByType(
    @Path("typeName") String typeName,
  );

  @GET("/pokemon/{query}")
  Future<PokemonListResponse> searchPokemon(
    @Path("query") String query,
  );

  @GET("/type")
  Future<TypeListResponse> getPokemonTypes();
}
