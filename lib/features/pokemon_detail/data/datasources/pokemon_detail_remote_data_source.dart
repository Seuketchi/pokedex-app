import 'package:pokedex_app/features/pokemon_detail/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/pokemon_detail_model.dart';

abstract class PokemonDetailRemoteDataSource {
  Future<PokemonDetailModel> getPokemonDetail(int id);

  Future<EvolutionChainModel> getEvolutionChain(int speciesId);
}
