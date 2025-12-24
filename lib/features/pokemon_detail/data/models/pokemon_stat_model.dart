import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_stat_model.freezed.dart';
part 'pokemon_stat_model.g.dart';

@freezed
class PokemonStatModel with _$PokemonStatModel {
  const factory PokemonStatModel({
    @JsonKey(name: 'base_stat') required int baseStat,
    required int effort,
    required StatInfoModel stat,
  }) = _PokemonStatModel;

  factory PokemonStatModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatModelFromJson(json);
}

@freezed
class StatInfoModel with _$StatInfoModel {
  const factory StatInfoModel({
    required String name,
  }) = _StatInfoModel;

  factory StatInfoModel.fromJson(Map<String, dynamic> json) =>
      _$StatInfoModelFromJson(json);
}
