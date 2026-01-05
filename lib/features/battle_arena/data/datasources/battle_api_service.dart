import 'package:dio/dio.dart';
import 'package:pokedex_app/features/battle_arena/data/models/move_model.dart';
import 'package:pokedex_app/features/battle_arena/data/models/pokemon_moves_response.dart';
import 'package:pokedex_app/features/battle_arena/data/models/type_effectiveness_model.dart';
import 'package:retrofit/retrofit.dart';

part 'battle_api_service.g.dart';

@RestApi(baseUrl: 'https://pokeapi.co/api/v2')
abstract class BattleApiService {
  factory BattleApiService(Dio dio, {String baseUrl}) = _BattleApiService;

  @GET('/pokemon/{id}')
  Future<PokemonMovesResponse> getPokemonMoves(
    @Path('id') int id,
  );

  @GET('/move/{id}')
  Future<MoveModel> getMove(
    @Path('id') int id,
  );

  @GET('/type/{name}')
  Future<TypeEffectivenessModel> getTypeEffectiveness(
    @Path('name') String name,
  );
}
