import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/features/pokemon_detail/data/models/evolution_node_model.dart';

part 'evolution_chain_model.freezed.dart';
part 'evolution_chain_model.g.dart';

@freezed
class EvolutionChainModel with _$EvolutionChainModel {
  const factory EvolutionChainModel({
    required int id,
    required EvolutionNodeModel chain,
  }) = _EvolutionChainModel;

  factory EvolutionChainModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionChainModelFromJson(json);
}
