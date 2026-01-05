import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/battle_arena/data/models/move_model.dart';

void main() {
  group('MoveModel', () {
    test('should create MoveModel from JSON', () {
      // arrange
      final json = {
        'id': 1,
        'name': 'tackle',
        'power': 40,
        'accuracy': 100,
        'pp': 35,
        'type': {
          'name': 'normal',
        },
      };

      // act
      final result = MoveModel.fromJson(json);

      // assert
      expect(result.id, equals(1));
      expect(result.name, equals('tackle'));
      expect(result.power, equals(40));
      expect(result.accuracy, equals(100));
      expect(result.pp, equals(35));
      expect(result.type.name, equals('normal'));
    });

    test('should create MoveModel from JSON with null power', () {
      // arrange
      final json = {
        'id': 2,
        'name': 'status-move',
        'power': null,
        'accuracy': 100,
        'pp': 20,
        'type': {
          'name': 'normal',
        },
      };

      // act
      final result = MoveModel.fromJson(json);

      // assert
      expect(result.id, equals(2));
      expect(result.name, equals('status-move'));
      expect(result.power, isNull);
      expect(result.accuracy, equals(100));
      expect(result.pp, equals(20));
      expect(result.type.name, equals('normal'));
    });

    test('should create MoveModel from JSON with null accuracy', () {
      // arrange
      final json = {
        'id': 3,
        'name': 'sure-hit-move',
        'power': 60,
        'accuracy': null,
        'pp': 15,
        'type': {
          'name': 'psychic',
        },
      };

      // act
      final result = MoveModel.fromJson(json);

      // assert
      expect(result.id, equals(3));
      expect(result.name, equals('sure-hit-move'));
      expect(result.power, equals(60));
      expect(result.accuracy, isNull);
      expect(result.pp, equals(15));
      expect(result.type.name, equals('psychic'));
    });

    test('should support equality comparison', () {
      // arrange
      const moveModel1 = MoveModel(
        id: 1,
        name: 'tackle',
        power: 40,
        accuracy: 100,
        pp: 35,
        type: MoveTypeModel(name: 'normal'),
      );

      const moveModel2 = MoveModel(
        id: 1,
        name: 'tackle',
        power: 40,
        accuracy: 100,
        pp: 35,
        type: MoveTypeModel(name: 'normal'),
      );

      const moveModel3 = MoveModel(
        id: 2,
        name: 'thunder-shock',
        power: 40,
        accuracy: 100,
        pp: 30,
        type: MoveTypeModel(name: 'electric'),
      );

      // act & assert
      expect(moveModel1, equals(moveModel2));
      expect(moveModel1, isNot(equals(moveModel3)));
    });
  });

  group('MoveTypeModel', () {
    test('should create MoveTypeModel from JSON', () {
      // arrange
      final json = {'name': 'fire'};

      // act
      final result = MoveTypeModel.fromJson(json);

      // assert
      expect(result.name, equals('fire'));
    });

    test('should support equality comparison', () {
      // arrange
      const type1 = MoveTypeModel(name: 'fire');
      const type2 = MoveTypeModel(name: 'fire');
      const type3 = MoveTypeModel(name: 'water');

      // act & assert
      expect(type1, equals(type2));
      expect(type1, isNot(equals(type3)));
    });
  });
}
