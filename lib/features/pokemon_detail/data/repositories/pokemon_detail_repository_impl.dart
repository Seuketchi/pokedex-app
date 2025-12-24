import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_detail/data/datasources/pokemon_detail_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/mapper/evolution_chain_mapper.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/mapper/pokemon_detail_mapper.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/repositories/pokemon_detail_repository.dart';

@Singleton(as: PokemonDetailRepository)
class PokemonDetailRepositoryImpl implements PokemonDetailRepository {
  PokemonDetailRepositoryImpl(this.remoteDataSource);

  final PokemonDetailRemoteDataSource remoteDataSource;

  @override
  Future<Result<PokemonDetail, Failure>> getPokemonDetail(int id) async {
    try {
      final detailModel = await remoteDataSource.getPokemonDetail(id);
      final detail = detailModel.toDomain();
      return ResultSuccess(detail);
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
  Future<Result<EvolutionChain, Failure>> getEvolutionChain(
    int speciesId,
  ) async {
    try {
      final chainModel = await remoteDataSource.getEvolutionChain(speciesId);
      final chain = chainModel.toDomain();
      return ResultSuccess(chain);
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
