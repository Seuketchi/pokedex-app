import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_type.freezed.dart';

@freezed
class PokemonType with _$PokemonType {
  const factory PokemonType({
    required String name,
    required int slot,
  }) = _PokemonType;
}
