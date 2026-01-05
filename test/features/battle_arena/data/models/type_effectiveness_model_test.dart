import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/battle_arena/data/models/type_effectiveness_model.dart';

void main() {
  group('TypeEffectivenessModel', () {
    test('should create TypeEffectivenessModel from JSON', () {
      // arrange
      final json = {
        'name': 'fire',
        'damage_relations': {
          'double_damage_to': [
            {'name': 'grass'},
            {'name': 'ice'},
          ],
          'half_damage_to': [
            {'name': 'water'},
            {'name': 'rock'},
          ],
          'no_damage_to': <Map<String, dynamic>>[],
        },
      };

      // act
      final result = TypeEffectivenessModel.fromJson(json);

      // assert
      expect(result.name, equals('fire'));
      expect(result.damageRelations.doubleDamageTo, hasLength(2));
      expect(result.damageRelations.doubleDamageTo[0].name, equals('grass'));
      expect(result.damageRelations.doubleDamageTo[1].name, equals('ice'));

      expect(result.damageRelations.halfDamageTo, hasLength(2));
      expect(result.damageRelations.halfDamageTo[0].name, equals('water'));
      expect(result.damageRelations.halfDamageTo[1].name, equals('rock'));

      expect(result.damageRelations.noDamageTo, isEmpty);
    });

    test(
      'should create TypeEffectivenessModel from JSON with no damage relationships',
      () {
        // arrange
        final json = {
          'name': 'normal',
          'damage_relations': {
            'double_damage_to': <Map<String, dynamic>>[],
            'half_damage_to': <Map<String, dynamic>>[],
            'no_damage_to': [
              {'name': 'ghost'},
            ],
          },
        };

        // act
        final result = TypeEffectivenessModel.fromJson(json);

        // assert
        expect(result.name, equals('normal'));
        expect(result.damageRelations.doubleDamageTo, isEmpty);
        expect(result.damageRelations.halfDamageTo, isEmpty);
        expect(result.damageRelations.noDamageTo, hasLength(1));
        expect(result.damageRelations.noDamageTo[0].name, equals('ghost'));
      },
    );

    test('should handle complex type effectiveness data', () {
      // arrange - Example for Electric type
      final json = {
        'name': 'electric',
        'damage_relations': {
          'double_damage_to': [
            {'name': 'flying'},
            {'name': 'water'},
          ],
          'half_damage_to': [
            {'name': 'electric'},
            {'name': 'grass'},
            {'name': 'dragon'},
          ],
          'no_damage_to': [
            {'name': 'ground'},
          ],
        },
      };

      // act
      final result = TypeEffectivenessModel.fromJson(json);

      // assert
      expect(result.name, equals('electric'));
      expect(result.damageRelations.doubleDamageTo, hasLength(2));
      expect(
        result.damageRelations.doubleDamageTo.map((t) => t.name),
        containsAll(['flying', 'water']),
      );

      expect(result.damageRelations.halfDamageTo, hasLength(3));
      expect(
        result.damageRelations.halfDamageTo.map((t) => t.name),
        containsAll(['electric', 'grass', 'dragon']),
      );

      expect(result.damageRelations.noDamageTo, hasLength(1));
      expect(result.damageRelations.noDamageTo[0].name, equals('ground'));
    });
  });

  group('DamageRelationsModel', () {
    test('should create DamageRelationsModel from JSON', () {
      // arrange
      final json = {
        'double_damage_to': [
          {'name': 'grass'},
        ],
        'half_damage_to': [
          {'name': 'water'},
        ],
        'no_damage_to': <Map<String, dynamic>>[],
      };

      // act
      final result = DamageRelationsModel.fromJson(json);

      // assert
      expect(result.doubleDamageTo, hasLength(1));
      expect(result.doubleDamageTo[0].name, equals('grass'));
      expect(result.halfDamageTo, hasLength(1));
      expect(result.halfDamageTo[0].name, equals('water'));
      expect(result.noDamageTo, isEmpty);
    });
  });

  group('TypeNameModel', () {
    test('should create TypeNameModel from JSON', () {
      // arrange
      final json = {'name': 'fire'};

      // act
      final result = TypeNameModel.fromJson(json);

      // assert
      expect(result.name, equals('fire'));
    });

    test('should support equality comparison', () {
      // arrange
      const type1 = TypeNameModel(name: 'fire');
      const type2 = TypeNameModel(name: 'fire');
      const type3 = TypeNameModel(name: 'water');

      // act & assert
      expect(type1, equals(type2));
      expect(type1, isNot(equals(type3)));
    });
  });
}
