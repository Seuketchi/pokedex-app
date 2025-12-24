import 'package:pokedex_app/features/pokemon_detail/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/evolution_node_model.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_chain.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_node.dart';

extension EvolutionChainMapper on EvolutionChainModel {
  EvolutionChain toDomain() {
    return EvolutionChain(
      id: id,
      chain: chain.toDomain(),
    );
  }
}

extension EvolutionNodeMapper on EvolutionNodeModel {
  EvolutionNode toDomain() {
    final detail = evolutionDetails.isNotEmpty ? evolutionDetails.first : null;

    return EvolutionNode(
      speciesName: species.name,
      speciesId: species.id,
      trigger: detail?.trigger?.name,
      minLevel: detail?.minLevel,
      item: detail?.item?.name,
      evolvesTo: evolvesTo.map((node) => node.toDomain()).toList(),
    );
  }
}
