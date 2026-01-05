import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/battle_arena/data/models/pokemon_moves_response.dart';

void main() {
  group('PokemonMovesResponse', () {
    test('should create PokemonMovesResponse from JSON', () {
      // arrange
      final json = {
        'moves': [
          {
            'move': {
              'name': 'tackle',
              'url': 'https://pokeapi.co/api/v2/move/33/',
            },
          },
          {
            'move': {
              'name': 'thunder-shock',
              'url': 'https://pokeapi.co/api/v2/move/84/',
            },
          },
        ],
      };

      // act
      final result = PokemonMovesResponse.fromJson(json);

      // assert
      expect(result.moves, hasLength(2));
      expect(result.moves.first.move.name, equals('tackle'));
      expect(
        result.moves.first.move.url,
        equals('https://pokeapi.co/api/v2/move/33/'),
      );
      expect(result.moves.last.move.name, equals('thunder-shock'));
      expect(
        result.moves.last.move.url,
        equals('https://pokeapi.co/api/v2/move/84/'),
      );
    });

    test('should create PokemonMovesResponse with empty moves list', () {
      // arrange
      final json = {
        'moves': <Map<String, dynamic>>[],
      };

      // act
      final result = PokemonMovesResponse.fromJson(json);

      // assert
      expect(result.moves, isEmpty);
    });

    test('should support equality comparison', () {
      // arrange
      const response1 = PokemonMovesResponse(
        moves: [
          PokemonMoveSlot(
            move: MoveInfoModel(
              name: 'tackle',
              url: 'https://pokeapi.co/api/v2/move/33/',
            ),
          ),
        ],
      );

      const response2 = PokemonMovesResponse(
        moves: [
          PokemonMoveSlot(
            move: MoveInfoModel(
              name: 'tackle',
              url: 'https://pokeapi.co/api/v2/move/33/',
            ),
          ),
        ],
      );

      const response3 = PokemonMovesResponse(
        moves: [
          PokemonMoveSlot(
            move: MoveInfoModel(
              name: 'thunder-shock',
              url: 'https://pokeapi.co/api/v2/move/84/',
            ),
          ),
        ],
      );

      // act & assert
      expect(response1, equals(response2));
      expect(response1, isNot(equals(response3)));
    });
  });

  group('PokemonMoveSlot', () {
    test('should create PokemonMoveSlot from JSON', () {
      // arrange
      final json = {
        'move': {
          'name': 'tackle',
          'url': 'https://pokeapi.co/api/v2/move/33/',
        },
      };

      // act
      final result = PokemonMoveSlot.fromJson(json);

      // assert
      expect(result.move.name, equals('tackle'));
      expect(result.move.url, equals('https://pokeapi.co/api/v2/move/33/'));
    });

    test('should support equality comparison', () {
      // arrange
      const slot1 = PokemonMoveSlot(
        move: MoveInfoModel(
          name: 'tackle',
          url: 'https://pokeapi.co/api/v2/move/33/',
        ),
      );

      const slot2 = PokemonMoveSlot(
        move: MoveInfoModel(
          name: 'tackle',
          url: 'https://pokeapi.co/api/v2/move/33/',
        ),
      );

      const slot3 = PokemonMoveSlot(
        move: MoveInfoModel(
          name: 'thunder-shock',
          url: 'https://pokeapi.co/api/v2/move/84/',
        ),
      );

      // act & assert
      expect(slot1, equals(slot2));
      expect(slot1, isNot(equals(slot3)));
    });
  });

  group('MoveInfoModel', () {
    test('should create MoveInfoModel from JSON', () {
      // arrange
      final json = {
        'name': 'tackle',
        'url': 'https://pokeapi.co/api/v2/move/33/',
      };

      // act
      final result = MoveInfoModel.fromJson(json);

      // assert
      expect(result.name, equals('tackle'));
      expect(result.url, equals('https://pokeapi.co/api/v2/move/33/'));
    });

    test('should support equality comparison', () {
      // arrange
      const moveInfo1 = MoveInfoModel(
        name: 'tackle',
        url: 'https://pokeapi.co/api/v2/move/33/',
      );

      const moveInfo2 = MoveInfoModel(
        name: 'tackle',
        url: 'https://pokeapi.co/api/v2/move/33/',
      );

      const moveInfo3 = MoveInfoModel(
        name: 'thunder-shock',
        url: 'https://pokeapi.co/api/v2/move/84/',
      );

      // act & assert
      expect(moveInfo1, equals(moveInfo2));
      expect(moveInfo1, isNot(equals(moveInfo3)));
    });
  });
}
