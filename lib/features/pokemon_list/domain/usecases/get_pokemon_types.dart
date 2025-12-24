import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/pokemon_list/domain/entities/type.dart';
import 'package:pokedex_app/features/pokemon_list/domain/repositories/pokemon_repository.dart';

@injectable
class GetPokemonTypes implements UseCase<List<Type>, NoParams> {
  GetPokemonTypes(this.repository);

  final PokemonRepository repository;

  @override
  Future<Result<List<Type>, Failure>> call(NoParams params) async {
    return repository.getPokemonTypes();
  }
}
