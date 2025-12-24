// features/pokemon_list/data/models/pokemon_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/core/converter/id_to_image_url_converter.dart';

part 'pokemon_model.freezed.dart';
part 'pokemon_model.g.dart';

@freezed
class PokemonModel with _$PokemonModel {
  const factory PokemonModel({
    required String name,
    @IdToImageUrlConverter() @JsonKey(name: 'url') required String imageUrl,
  }) = _PokemonModel;

  factory PokemonModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonModelFromJson(json);
}
