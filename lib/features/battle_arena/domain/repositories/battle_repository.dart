import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/type_effectiveness.dart';

abstract class BattleRepository {
  Future<Result<List<Move>, Failure>> getPokemonMoves(int pokemonId);

  Future<Result<TypeEffectiveness, Failure>> getTypeEffectiveness(
    String typeName,
  );
}
