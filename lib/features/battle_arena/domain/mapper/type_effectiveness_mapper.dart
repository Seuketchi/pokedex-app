import 'package:pokedex_app/features/battle_arena/data/models/type_effectiveness_model.dart';
import 'package:pokedex_app/features/battle_arena/domain/entities/type_effectiveness.dart';

extension TypeEffectivenessModelMapper on TypeEffectivenessModel {
  TypeEffectiveness toDomain() {
    return TypeEffectiveness(
      typeName: name,
      doubleDamageTo: damageRelations.doubleDamageTo
          .map((t) => t.name)
          .toList(),
      halfDamageTo: damageRelations.halfDamageTo.map((t) => t.name).toList(),
      noDamageTo: damageRelations.noDamageTo.map((t) => t.name).toList(),
    );
  }
}
