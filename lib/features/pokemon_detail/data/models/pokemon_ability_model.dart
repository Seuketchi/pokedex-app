import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_ability_model.freezed.dart';
part 'pokemon_ability_model.g.dart';

@freezed
class PokemonAbilityModel with _$PokemonAbilityModel {
  const factory PokemonAbilityModel({
    @JsonKey(name: 'is_hidden') required bool isHidden,
    required int slot,
    required AbilityInfoModel ability,
  }) = _PokemonAbilityModel;

  factory PokemonAbilityModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilityModelFromJson(json);
}

@freezed
class AbilityInfoModel with _$AbilityInfoModel {
  const factory AbilityInfoModel({
    required String name,
  }) = _AbilityInfoModel;

  factory AbilityInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AbilityInfoModelFromJson(json);
}
