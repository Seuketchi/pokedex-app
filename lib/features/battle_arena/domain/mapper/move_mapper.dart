import 'package:pokedex_app/features/battle_arena/data/models/move_model.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/move.dart';

extension MoveModelMapper on MoveModel {
  Move? toDomain() {
    if (power == null || power! <= 0) {
      return null;
    }

    return Move(
      id: id,
      name: name,
      power: power ?? 0,
      accuracy: accuracy ?? 0,
      pp: pp ?? 0,
      type: type.name,
    );
  }
}
