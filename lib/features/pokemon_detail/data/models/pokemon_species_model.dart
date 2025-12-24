import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/core/converter/url_id_converter.dart';

part 'pokemon_species_model.freezed.dart';
part 'pokemon_species_model.g.dart';

@freezed
class PokemonSpeciesModel with _$PokemonSpeciesModel {
  const factory PokemonSpeciesModel({
    required int id,
    required String name,
    @JsonKey(name: 'evolution_chain')
    required EvolutionChainUrlModel evolutionChain,
  }) = _PokemonSpeciesModel;

  factory PokemonSpeciesModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpeciesModelFromJson(json);
}

@freezed
class EvolutionChainUrlModel with _$EvolutionChainUrlModel {
  const factory EvolutionChainUrlModel({
    @UrlIdConverter() @JsonKey(name: 'url') required int id,
  }) = _EvolutionChainUrlModel;

  factory EvolutionChainUrlModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionChainUrlModelFromJson(json);
}
