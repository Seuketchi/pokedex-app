import 'package:freezed_annotation/freezed_annotation.dart';

part 'move_model.freezed.dart';
part 'move_model.g.dart';

@freezed
class MoveModel with _$MoveModel {
  const factory MoveModel({
    required int id,
    required String name,
    required int? power,
    required int? accuracy,
    required int? pp,
    required MoveTypeModel type,
  }) = _MoveModel;

  factory MoveModel.fromJson(Map<String, dynamic> json) =>
      _$MoveModelFromJson(json);
}

@freezed
class MoveTypeModel with _$MoveTypeModel {
  const factory MoveTypeModel({
    required String name,
  }) = _MoveTypeModel;

  factory MoveTypeModel.fromJson(Map<String, dynamic> json) =>
      _$MoveTypeModelFromJson(json);
}
