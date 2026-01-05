import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';

part 'battle_pokemon.freezed.dart';

@freezed
class BattlePokemon with _$BattlePokemon {
  const factory BattlePokemon({
    required int id,
    required String name,
    required String imageUrl,
    required List<String> types,
    required int maxHp,
    required int currentHp,
    required int attack,
    required int defense,
    required int speed,
    required List<Move> moves,
  }) = _BattlePokemon;
}
