import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/pokemon.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';

@injectable
class FilterByType implements UseCase<List<Pokemon>, String> {
  FilterByType(this.repository);

  final PokemonRepository repository;

  @override
  Future<Result<List<Pokemon>, Failure>> call(String type) {
    return repository.filterByType(type);
  }
}
