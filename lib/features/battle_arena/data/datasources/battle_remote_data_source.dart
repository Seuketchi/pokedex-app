import 'package:pokedex_app/features/battle_arena/data/models/move_model.dart';
import 'package:pokedex_app/features/battle_arena/data/models/type_effectiveness_model.dart';

abstract class BattleRemoteDataSource {
  Future<List<MoveModel>> getPokemonMoves(int pokemonId);

  Future<TypeEffectivenessModel> getTypeEffectiveness(String typeName);
}
