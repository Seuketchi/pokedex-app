import 'package:freezed_annotation/freezed_annotation.dart';

part 'type_effectiveness_model.freezed.dart';
part 'type_effectiveness_model.g.dart';

@freezed
class TypeEffectivenessModel with _$TypeEffectivenessModel {
  const factory TypeEffectivenessModel({
    required String name,
    @JsonKey(name: 'damage_relations')
    required DamageRelationsModel damageRelations,
  }) = _TypeEffectivenessModel;

  factory TypeEffectivenessModel.fromJson(Map<String, dynamic> json) =>
      _$TypeEffectivenessModelFromJson(json);
}

@freezed
class DamageRelationsModel with _$DamageRelationsModel {
  const factory DamageRelationsModel({
    @JsonKey(name: 'double_damage_to')
    required List<TypeNameModel> doubleDamageTo,
    @JsonKey(name: 'half_damage_to') required List<TypeNameModel> halfDamageTo,
    @JsonKey(name: 'no_damage_to') required List<TypeNameModel> noDamageTo,
  }) = _DamageRelationsModel;

  factory DamageRelationsModel.fromJson(Map<String, dynamic> json) =>
      _$DamageRelationsModelFromJson(json);
}

@freezed
class TypeNameModel with _$TypeNameModel {
  const factory TypeNameModel({
    required String name,
  }) = _TypeNameModel;

  factory TypeNameModel.fromJson(Map<String, dynamic> json) =>
      _$TypeNameModelFromJson(json);
}
