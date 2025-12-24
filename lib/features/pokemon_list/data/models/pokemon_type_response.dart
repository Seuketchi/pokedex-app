import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/pokemon_model.dart';

part 'pokemon_type_response.freezed.dart';
part 'pokemon_type_response.g.dart';

@freezed
class PokemonTypeResponse with _$PokemonTypeResponse {
  const factory PokemonTypeResponse({
    required List<PokemonTypeSlot> pokemon,
  }) = _PokemonTypeResponse;

  factory PokemonTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeResponseFromJson(json);
}

@freezed
class PokemonTypeSlot with _$PokemonTypeSlot {
  const factory PokemonTypeSlot({
    required PokemonModel pokemon,
  }) = _PokemonTypeSlot;

  factory PokemonTypeSlot.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeSlotFromJson(json);
}
