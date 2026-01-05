import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/battle_arena/data/datasources/battle_remote_data_source.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/type_effectiveness.dart';
import 'package:pokedex_app/features/battle_arena/domain/mapper/move_mapper.dart';
import 'package:pokedex_app/features/battle_arena/domain/mapper/type_effectiveness_mapper.dart';
import 'package:pokedex_app/features/battle_arena/domain/repositories/battle_repository.dart';

@Singleton(as: BattleRepository)
class BattleRepositoryImpl implements BattleRepository {
  BattleRepositoryImpl(this.remoteDataSource);

  final BattleRemoteDataSource remoteDataSource;

  @override
  Future<Result<List<Move>, Failure>> getPokemonMoves(int pokemonId) async {
    try {
      final moveModels = await remoteDataSource.getPokemonMoves(pokemonId);

      // Map and filter out null moves (status moves)
      final moves = moveModels
          .map((model) => model.toDomain())
          .where((move) => move != null)
          .cast<Move>()
          .toList();

      return ResultSuccess(moves);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Result.failure(
        ServerFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<TypeEffectiveness, Failure>> getTypeEffectiveness(
    String typeName,
  ) async {
    try {
      final model = await remoteDataSource.getTypeEffectiveness(typeName);
      final effectiveness = model.toDomain();
      return ResultSuccess(effectiveness);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Result.failure(
        ServerFailure(message: e.toString()),
      );
    }
  }
}
