import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/features/pokemon_list/data/models/type_model.dart';

part 'type_list_response.freezed.dart';
part 'type_list_response.g.dart';

@freezed
class TypeListResponse with _$TypeListResponse {
  const factory TypeListResponse({
    required List<TypeModel> results,
  }) = _TypeListResponse;

  factory TypeListResponse.fromJson(Map<String, dynamic> json) =>
      _$TypeListResponseFromJson(json);
}
