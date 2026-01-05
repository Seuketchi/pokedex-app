import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/battle_arena/data/models/move_model.dart';
import 'package:pokedex_app/features/battle_arena/domain/mapper/move_mapper.dart';

void main() {
  group('MoveModelMapper', () {
    test('should map MoveModel to Move when power is valid', () {
      // arrange
      const moveModel = MoveModel(
        id: 1,
        name: 'tackle',
        power: 40,
        accuracy: 100,
        pp: 35,
        type: MoveTypeModel(name: 'normal'),
      );

      // act
      final result = moveModel.toDomain();

      // assert
      expect(result, isNotNull);
      expect(result!.id, equals(1));
      expect(result.name, equals('tackle'));
      expect(result.power, equals(40));
      expect(result.accuracy, equals(100));
      expect(result.pp, equals(35));
      expect(result.type, equals('normal'));
    });

    test('should return null when power is null', () {
      // arrange
      const moveModel = MoveModel(
        id: 2,
        name: 'status-move',
        power: null,
        accuracy: 100,
        pp: 20,
        type: MoveTypeModel(name: 'normal'),
      );

      // act
      final result = moveModel.toDomain();

      // assert
      expect(result, isNull);
    });

    test('should return null when power is zero', () {
      // arrange
      const moveModel = MoveModel(
        id: 3,
        name: 'zero-power-move',
        power: 0,
        accuracy: 100,
        pp: 15,
        type: MoveTypeModel(name: 'normal'),
      );

      // act
      final result = moveModel.toDomain();

      // assert
      expect(result, isNull);
    });

    test('should return null when power is negative', () {
      // arrange
      const moveModel = MoveModel(
        id: 4,
        name: 'negative-power-move',
        power: -10,
        accuracy: 100,
        pp: 10,
        type: MoveTypeModel(name: 'normal'),
      );

      // act
      final result = moveModel.toDomain();

      // assert
      expect(result, isNull);
    });

    test('should handle null accuracy by defaulting to 0', () {
      // arrange
      const moveModel = MoveModel(
        id: 5,
        name: 'sure-hit-move',
        power: 60,
        accuracy: null,
        pp: 15,
        type: MoveTypeModel(name: 'psychic'),
      );

      // act
      final result = moveModel.toDomain();

      // assert
      expect(result, isNotNull);
      expect(result!.accuracy, equals(0));
      expect(result.power, equals(60));
    });

    test('should handle null pp by defaulting to 0', () {
      // arrange
      const moveModel = MoveModel(
        id: 6,
        name: 'infinite-pp-move',
        power: 50,
        accuracy: 90,
        pp: null,
        type: MoveTypeModel(name: 'electric'),
      );

      // act
      final result = moveModel.toDomain();

      // assert
      expect(result, isNotNull);
      expect(result!.pp, equals(0));
      expect(result.power, equals(50));
    });

    test('should handle all null values except power correctly', () {
      // arrange
      const moveModel = MoveModel(
        id: 7,
        name: 'minimal-move',
        power: 1,
        accuracy: null,
        pp: null,
        type: MoveTypeModel(name: 'fighting'),
      );

      // act
      final result = moveModel.toDomain();

      // assert
      expect(result, isNotNull);
      expect(result!.id, equals(7));
      expect(result.name, equals('minimal-move'));
      expect(result.power, equals(1));
      expect(result.accuracy, equals(0));
      expect(result.pp, equals(0));
      expect(result.type, equals('fighting'));
    });

    test('should handle maximum values correctly', () {
      // arrange
      const moveModel = MoveModel(
        id: 999,
        name: 'max-power-move',
        power: 999,
        accuracy: 100,
        pp: 40,
        type: MoveTypeModel(name: 'dragon'),
      );

      // act
      final result = moveModel.toDomain();

      // assert
      expect(result, isNotNull);
      expect(result!.id, equals(999));
      expect(result.power, equals(999));
      expect(result.accuracy, equals(100));
      expect(result.pp, equals(40));
      expect(result.type, equals('dragon'));
    });

    test('should handle different type names correctly', () {
      // arrange
      const fireMove = MoveModel(
        id: 8,
        name: 'ember',
        power: 40,
        accuracy: 100,
        pp: 25,
        type: MoveTypeModel(name: 'fire'),
      );

      const waterMove = MoveModel(
        id: 9,
        name: 'water-gun',
        power: 40,
        accuracy: 100,
        pp: 25,
        type: MoveTypeModel(name: 'water'),
      );

      // act
      final fireResult = fireMove.toDomain();
      final waterResult = waterMove.toDomain();

      // assert
      expect(fireResult, isNotNull);
      expect(fireResult!.type, equals('fire'));

      expect(waterResult, isNotNull);
      expect(waterResult!.type, equals('water'));
    });
  });
}
