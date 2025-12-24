import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/repositories/pokemon_detail_repository.dart';

part 'get_evolution_chain.freezed.dart';

@injectable
class GetEvolutionChain implements UseCase<EvolutionChain, SpeciesIdParams> {
  GetEvolutionChain(this.repository);

  final PokemonDetailRepository repository;

  @override
  Future<Result<EvolutionChain, Failure>> call(
    SpeciesIdParams params,
  ) async {
    return repository.getEvolutionChain(params.speciesId);
  }
}

@freezed
class SpeciesIdParams with _$SpeciesIdParams {
  const factory SpeciesIdParams({required int speciesId}) = _SpeciesIdParams;
}
