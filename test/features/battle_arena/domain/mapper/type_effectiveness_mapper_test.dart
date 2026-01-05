import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/battle_arena/data/models/type_effectiveness_model.dart';
import 'package:pokedex_app/features/battle_arena/domain/mapper/type_effectiveness_mapper.dart';

void main() {
  group('TypeEffectivenessModelMapper', () {
    test(
      'should map TypeEffectivenessModel to TypeEffectiveness domain entity',
      () {
        // arrange
        const typeEffectivenessModel = TypeEffectivenessModel(
          name: 'fire',
          damageRelations: DamageRelationsModel(
            doubleDamageTo: [
              TypeNameModel(name: 'grass'),
              TypeNameModel(name: 'ice'),
              TypeNameModel(name: 'bug'),
            ],
            halfDamageTo: [
              TypeNameModel(name: 'water'),
              TypeNameModel(name: 'rock'),
            ],
            noDamageTo: <TypeNameModel>[],
          ),
        );

        // act
        final result = typeEffectivenessModel.toDomain();

        // assert
        expect(result.typeName, equals('fire'));
        expect(result.doubleDamageTo, hasLength(3));
        expect(result.doubleDamageTo, containsAll(['grass', 'ice', 'bug']));
        expect(result.halfDamageTo, hasLength(2));
        expect(result.halfDamageTo, containsAll(['water', 'rock']));
        expect(result.noDamageTo, isEmpty);
      },
    );

    test('should handle empty damage relations lists', () {
      // arrange
      const typeEffectivenessModel = TypeEffectivenessModel(
        name: 'normal',
        damageRelations: DamageRelationsModel(
          doubleDamageTo: <TypeNameModel>[],
          halfDamageTo: <TypeNameModel>[],
          noDamageTo: <TypeNameModel>[],
        ),
      );

      // act
      final result = typeEffectivenessModel.toDomain();

      // assert
      expect(result.typeName, equals('normal'));
      expect(result.doubleDamageTo, isEmpty);
      expect(result.halfDamageTo, isEmpty);
      expect(result.noDamageTo, isEmpty);
    });

    test('should handle type with no damage to certain types', () {
      // arrange
      const typeEffectivenessModel = TypeEffectivenessModel(
        name: 'normal',
        damageRelations: DamageRelationsModel(
          doubleDamageTo: <TypeNameModel>[],
          halfDamageTo: <TypeNameModel>[],
          noDamageTo: [
            TypeNameModel(name: 'ghost'),
          ],
        ),
      );

      // act
      final result = typeEffectivenessModel.toDomain();

      // assert
      expect(result.typeName, equals('normal'));
      expect(result.doubleDamageTo, isEmpty);
      expect(result.halfDamageTo, isEmpty);
      expect(result.noDamageTo, hasLength(1));
      expect(result.noDamageTo, contains('ghost'));
    });

    test('should handle complex type effectiveness mapping', () {
      // arrange - Electric type example
      const typeEffectivenessModel = TypeEffectivenessModel(
        name: 'electric',
        damageRelations: DamageRelationsModel(
          doubleDamageTo: [
            TypeNameModel(name: 'flying'),
            TypeNameModel(name: 'water'),
          ],
          halfDamageTo: [
            TypeNameModel(name: 'electric'),
            TypeNameModel(name: 'grass'),
            TypeNameModel(name: 'dragon'),
          ],
          noDamageTo: [
            TypeNameModel(name: 'ground'),
          ],
        ),
      );

      // act
      final result = typeEffectivenessModel.toDomain();

      // assert
      expect(result.typeName, equals('electric'));
      expect(result.doubleDamageTo, hasLength(2));
      expect(result.doubleDamageTo, containsAll(['flying', 'water']));
      expect(result.halfDamageTo, hasLength(3));
      expect(result.halfDamageTo, containsAll(['electric', 'grass', 'dragon']));
      expect(result.noDamageTo, hasLength(1));
      expect(result.noDamageTo, contains('ground'));
    });

    test('should preserve type name correctly', () {
      // arrange
      const typeEffectivenessModel = TypeEffectivenessModel(
        name: 'psychic',
        damageRelations: DamageRelationsModel(
          doubleDamageTo: [
            TypeNameModel(name: 'fighting'),
            TypeNameModel(name: 'poison'),
          ],
          halfDamageTo: <TypeNameModel>[],
          noDamageTo: <TypeNameModel>[],
        ),
      );

      // act
      final result = typeEffectivenessModel.toDomain();

      // assert
      expect(result.typeName, equals('psychic'));
      expect(result.doubleDamageTo, containsAll(['fighting', 'poison']));
    });

    test('should handle single type in each category', () {
      // arrange
      const typeEffectivenessModel = TypeEffectivenessModel(
        name: 'steel',
        damageRelations: DamageRelationsModel(
          doubleDamageTo: [
            TypeNameModel(name: 'rock'),
          ],
          halfDamageTo: [
            TypeNameModel(name: 'fire'),
          ],
          noDamageTo: [
            TypeNameModel(name: 'ghost'),
          ],
        ),
      );

      // act
      final result = typeEffectivenessModel.toDomain();

      // assert
      expect(result.typeName, equals('steel'));
      expect(result.doubleDamageTo, hasLength(1));
      expect(result.doubleDamageTo.first, equals('rock'));
      expect(result.halfDamageTo, hasLength(1));
      expect(result.halfDamageTo.first, equals('fire'));
      expect(result.noDamageTo, hasLength(1));
      expect(result.noDamageTo.first, equals('ghost'));
    });

    test('should handle multiple types of the same effectiveness', () {
      // arrange - Fighting type example
      const typeEffectivenessModel = TypeEffectivenessModel(
        name: 'fighting',
        damageRelations: DamageRelationsModel(
          doubleDamageTo: [
            TypeNameModel(name: 'normal'),
            TypeNameModel(name: 'rock'),
            TypeNameModel(name: 'steel'),
            TypeNameModel(name: 'ice'),
            TypeNameModel(name: 'dark'),
          ],
          halfDamageTo: [
            TypeNameModel(name: 'flying'),
            TypeNameModel(name: 'poison'),
            TypeNameModel(name: 'bug'),
            TypeNameModel(name: 'psychic'),
            TypeNameModel(name: 'fairy'),
          ],
          noDamageTo: [
            TypeNameModel(name: 'ghost'),
          ],
        ),
      );

      // act
      final result = typeEffectivenessModel.toDomain();

      // assert
      expect(result.typeName, equals('fighting'));
      expect(result.doubleDamageTo, hasLength(5));
      expect(
        result.doubleDamageTo,
        containsAll(['normal', 'rock', 'steel', 'ice', 'dark']),
      );
      expect(result.halfDamageTo, hasLength(5));
      expect(
        result.halfDamageTo,
        containsAll(['flying', 'poison', 'bug', 'psychic', 'fairy']),
      );
      expect(result.noDamageTo, hasLength(1));
      expect(result.noDamageTo, contains('ghost'));
    });
  });
}
