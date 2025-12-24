import 'package:freezed_annotation/freezed_annotation.dart';

part 'type.freezed.dart';

@freezed
class Type with _$Type {
  const factory Type({
    required int id,
    required String name,
  }) = _Type;
}
