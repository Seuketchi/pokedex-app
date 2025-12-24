import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_stat.freezed.dart';

@freezed
class PokemonStat with _$PokemonStat {
  const factory PokemonStat({
    required String name,
    required int baseStat,
    required int effort,
  }) = _PokemonStat;
}
