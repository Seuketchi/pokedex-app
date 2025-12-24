import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/repositories/pokemon_detail_repository.dart';

part 'get_pokemon_detail.freezed.dart';

@injectable
class GetPokemonDetail implements UseCase<PokemonDetail, PokemonIdParams> {
  GetPokemonDetail(this.repository);

  final PokemonDetailRepository repository;

  @override
  Future<Result<PokemonDetail, Failure>> call(
    PokemonIdParams params,
  ) async {
    return repository.getPokemonDetail(params.id);
  }
}

@freezed
class PokemonIdParams with _$PokemonIdParams {
  const factory PokemonIdParams({required int id}) = _PokemonIdParams;
}
