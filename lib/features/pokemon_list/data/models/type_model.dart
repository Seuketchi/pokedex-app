import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/core/converter/id_to_image_url_converter.dart';
import 'package:pokedex_app/core/converter/url_id_converter.dart';

part 'type_model.freezed.dart';
part 'type_model.g.dart';

@freezed
class TypeModel with _$TypeModel {
  const factory TypeModel({
    @UrlIdConverter() @JsonKey(name: 'url') required int id,
    required String name,
  }) = _TypeModel;

  factory TypeModel.fromJson(Map<String, dynamic> json) =>
      _$TypeModelFromJson(json);
}
