import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_list/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/type.dart';
import 'package:pokedex_app/features/pokemon_list/domain/mapper/pokemon_mapper.dart';
import 'package:pokedex_app/features/pokemon_list/domain/mapper/type_mapper.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';

@Singleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl(this.remoteDataSource);

  final PokemonRemoteDataSource remoteDataSource;

  @override
  Future<Result<List<Pokemon>, Failure>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    try {
      final pokemonModels = await remoteDataSource.getPokemonList(
        limit: limit,
        offset: offset,
      );

      final pokemon = pokemonModels.map((model) => model.toDomain()).toList();

      return ResultSuccess(pokemon);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(message: e.message));
    } on Exception catch (e) {
      // Fallback for any other exceptions
      return Result.failure(
        ServerFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Result<List<Pokemon>, Failure>> filterByType(String typeName) async {
    try {
      final pokemonModels = await remoteDataSource.getPokemonByType(typeName);
      final pokemon = pokemonModels.map((model) => model.toDomain()).toList();
      return ResultSuccess(pokemon);
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
  Future<Result<List<Pokemon>, Failure>> searchPokemon(String query) async {
    try {
      final pokemonModels = await remoteDataSource.searchPokemon(query);
      final pokemon = pokemonModels.map((model) => model.toDomain()).toList();
      return ResultSuccess(pokemon);
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
  Future<Result<List<Type>, Failure>> getPokemonTypes() async {
    try {
      final typeModels = await remoteDataSource.getPokemonTypes();
      final types = typeModels.map((model) => model.toDomain()).toList();
      return ResultSuccess(types);
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
