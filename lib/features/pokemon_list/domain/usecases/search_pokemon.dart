import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';

@injectable
class SearchPokemon implements UseCase<List<Pokemon>, String> {
  SearchPokemon(this.repository);

  final PokemonRepository repository;

  @override
  Future<Result<List<Pokemon>, Failure>> call(String params) {
    return repository.searchPokemon(params);
  }
}
