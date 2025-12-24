import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/constants/api_constants.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';

@injectable
class GetPokemonList implements UseCase<List<Pokemon>, PaginationParams> {
  GetPokemonList(this.repository);

  final PokemonRepository repository;

  @override
  Future<Result<List<Pokemon>, Failure>> call(
    PaginationParams params,
  ) async {
    return repository.getPokemonList(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class PaginationParams {
  PaginationParams({
    this.limit = ApiConstants.defaultLimit,
    this.offset = 0,
  });

  final int limit;
  final int offset;
}
