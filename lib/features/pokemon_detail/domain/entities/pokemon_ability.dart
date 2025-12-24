import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_ability.freezed.dart';

@freezed
class PokemonAbility with _$PokemonAbility {
  const factory PokemonAbility({
    required String name,
    required bool isHidden,
    required int slot,
  }) = _PokemonAbility;
}
