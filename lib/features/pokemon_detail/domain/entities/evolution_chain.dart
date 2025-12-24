import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/evolution_node.dart';

part 'evolution_chain.freezed.dart';

@freezed
class EvolutionChain with _$EvolutionChain {
  const factory EvolutionChain({
    required int id,
    required EvolutionNode chain,
  }) = _EvolutionChain;
}
