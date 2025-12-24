import 'package:freezed_annotation/freezed_annotation.dart';

part 'evolution_node.freezed.dart';

@freezed
class EvolutionNode with _$EvolutionNode {
  const factory EvolutionNode({
    required String speciesName,
    required int speciesId,
    String? trigger,
    int? minLevel,
    String? item,
    required List<EvolutionNode> evolvesTo,
  }) = _EvolutionNode;
}
