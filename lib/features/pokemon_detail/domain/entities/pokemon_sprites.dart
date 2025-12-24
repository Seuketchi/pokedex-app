import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_sprites.freezed.dart';

@freezed
class PokemonSprites with _$PokemonSprites {
  const factory PokemonSprites({
    required String frontDefault,
    String? frontShiny,
    String? frontFemale,
    String? frontShinyFemale,
    String? backDefault,
    String? backShiny,
    String? backFemale,
    String? backShinyFemale,
    String? officialArtwork,
  }) = _PokemonSprites;
}
