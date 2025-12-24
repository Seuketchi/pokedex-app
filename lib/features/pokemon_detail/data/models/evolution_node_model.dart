import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/core/converter/url_id_converter.dart';

part 'evolution_node_model.freezed.dart';
part 'evolution_node_model.g.dart';

@freezed
class EvolutionNodeModel with _$EvolutionNodeModel {
  const factory EvolutionNodeModel({
    required SpeciesInfoModel species,
    @JsonKey(name: 'evolution_details')
    required List<EvolutionDetailModel> evolutionDetails,
    @JsonKey(name: 'evolves_to') required List<EvolutionNodeModel> evolvesTo,
  }) = _EvolutionNodeModel;

  factory EvolutionNodeModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionNodeModelFromJson(json);
}

@freezed
class SpeciesInfoModel with _$SpeciesInfoModel {
  const factory SpeciesInfoModel({
    required String name,
    @UrlIdConverter() @JsonKey(name: 'url') required int id,
  }) = _SpeciesInfoModel;

  factory SpeciesInfoModel.fromJson(Map<String, dynamic> json) =>
      _$SpeciesInfoModelFromJson(json);
}

@freezed
class EvolutionDetailModel with _$EvolutionDetailModel {
  const factory EvolutionDetailModel({
    @JsonKey(name: 'min_level') int? minLevel,
    EvolutionItemModel? item,
    EvolutionTriggerModel? trigger,
  }) = _EvolutionDetailModel;

  factory EvolutionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionDetailModelFromJson(json);
}

@freezed
class EvolutionItemModel with _$EvolutionItemModel {
  const factory EvolutionItemModel({
    required String name,
  }) = _EvolutionItemModel;

  factory EvolutionItemModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionItemModelFromJson(json);
}

@freezed
class EvolutionTriggerModel with _$EvolutionTriggerModel {
  const factory EvolutionTriggerModel({
    required String name,
  }) = _EvolutionTriggerModel;

  factory EvolutionTriggerModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionTriggerModelFromJson(json);
}
