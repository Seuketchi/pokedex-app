import 'package:freezed_annotation/freezed_annotation.dart';

part 'type_effectiveness.freezed.dart';

@freezed
class TypeEffectiveness with _$TypeEffectiveness {
  const factory TypeEffectiveness({
    required String typeName,
    required List<String> doubleDamageTo,
    required List<String> halfDamageTo,
    required List<String> noDamageTo,
  }) = _TypeEffectiveness;
}
