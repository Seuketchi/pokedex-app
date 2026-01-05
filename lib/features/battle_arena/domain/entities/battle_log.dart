import 'package:freezed_annotation/freezed_annotation.dart';

part 'battle_log.freezed.dart';

@freezed
class BattleLog with _$BattleLog {
  const factory BattleLog({
    required String message,
    required DateTime timestamp,
  }) = _BattleLog;
}
