import 'package:pokedex_app/core/error/failures.dart';
import 'package:pokedex_app/core/result/result.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_detail.dart';

abstract class PokemonDetailRepository {
  Future<Result<PokemonDetail, Failure>> getPokemonDetail(int id);

  Future<Result<EvolutionChain, Failure>> getEvolutionChain(int speciesId);
}
