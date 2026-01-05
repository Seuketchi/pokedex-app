import 'package:freezed_annotation/freezed_annotation.dart';

part 'move.freezed.dart';

@freezed
class Move with _$Move {
  const factory Move({
    required int id,
    required String name,
    required int power,
    required int accuracy,
    required int pp,
    required String type,
  }) = _Move;
}
