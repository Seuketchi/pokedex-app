import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_type_model.freezed.dart';
part 'pokemon_type_model.g.dart';

@freezed
class PokemonTypeModel with _$PokemonTypeModel {
  const factory PokemonTypeModel({
    required int slot,
    required TypeInfoModel type,
  }) = _PokemonTypeModel;

  factory PokemonTypeModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeModelFromJson(json);
}

@freezed
class TypeInfoModel with _$TypeInfoModel {
  const factory TypeInfoModel({
    required String name,
  }) = _TypeInfoModel;

  factory TypeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TypeInfoModelFromJson(json);
}
