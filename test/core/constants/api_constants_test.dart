import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/constants/api_constants.dart';

// NOTE:
// These tests are written for ApiConstants, which are static, immutable values.
// Unlike typical Flutter tests that interact with widgets or services,
// these tests verify constants and URL construction behave as expected.

void main() {
  group('ApiConstants', () {
    group('Base URL', () {
      test(
        'GIVEN ApiConstants WHEN accessing baseUrl THEN it should be correct',
        () {
          // Act
          const baseUrl = ApiConstants.baseUrl;

          // Assert
          expect(baseUrl, 'https://pokeapi.co/api/v2');
        },
      );

      test(
        'GIVEN ApiConstants WHEN accessing baseUrl THEN it should not have trailing slash',
        () {
          // Act
          const baseUrl = ApiConstants.baseUrl;

          // Assert
          expect(baseUrl.endsWith('/'), false);
        },
      );
    });

    group('Endpoints', () {
      test(
        'GIVEN ApiConstants WHEN calling pokemonById THEN it returns correct path',
        () {
          // Act & Assert
          expect(ApiConstants.pokemonById(25), '/pokemon/25');
          expect(ApiConstants.pokemonById(1), '/pokemon/1');
          expect(ApiConstants.pokemonById(151), '/pokemon/151');
        },
      );

      test(
        'GIVEN ApiConstants WHEN calling pokemonByName THEN it returns correct path',
        () {
          // Act & Assert
          expect(ApiConstants.pokemonByName('pikachu'), '/pokemon/pikachu');
          expect(ApiConstants.pokemonByName('bulbasaur'), '/pokemon/bulbasaur');
        },
      );

      test(
        'GIVEN ApiConstants WHEN calling pokemonSpecies THEN it returns correct path',
        () {
          // Act
          final path = ApiConstants.pokemonSpecies(25);

          // Assert
          expect(path, '/pokemon-species/25');
        },
      );

      test(
        'GIVEN ApiConstants WHEN calling evolutionChain THEN it returns correct path',
        () {
          // Act
          final path = ApiConstants.evolutionChain(10);

          // Assert
          expect(path, '/evolution-chain/10');
        },
      );

      test(
        'GIVEN ApiConstants WHEN calling type THEN it returns correct path',
        () {
          // Act
          final path = ApiConstants.type(13);

          // Assert
          expect(path, '/type/13');
        },
      );

      test(
        'GIVEN ApiConstants WHEN calling typeByName THEN it returns correct path',
        () {
          // Act
          final path = ApiConstants.typeByName('electric');

          // Assert
          expect(path, '/type/electric');
        },
      );
    });

    group('Timeouts', () {
      test(
        'GIVEN ApiConstants WHEN accessing connectTimeout THEN it should be 30 seconds',
        () {
          // Act & Assert
          expect(ApiConstants.connectTimeout, 30000);
        },
      );

      test(
        'GIVEN ApiConstants WHEN accessing receiveTimeout THEN it should be 30 seconds',
        () {
          // Act & Assert
          expect(ApiConstants.receiveTimeout, 30000);
        },
      );

      test(
        'GIVEN ApiConstants WHEN accessing sendTimeout THEN it should be 30 seconds',
        () {
          // Act & Assert
          expect(ApiConstants.sendTimeout, 30000);
        },
      );
    });

    group('Pagination', () {
      test(
        'GIVEN ApiConstants WHEN checking defaultLimit THEN it should be 20',
        () {
          // Act & Assert
          expect(ApiConstants.defaultLimit, 20);
        },
      );

      test(
        'GIVEN ApiConstants WHEN checking maxLimit THEN it should be 100',
        () {
          // Act & Assert
          expect(ApiConstants.maxLimit, 100);
        },
      );

      test(
        'GIVEN ApiConstants WHEN checking firstGenCount THEN it should be 151',
        () {
          // Act & Assert
          expect(ApiConstants.firstGenCount, 151);
        },
      );
    });

    group('URL Construction', () {
      test(
        'GIVEN ApiConstants WHEN building full URL THEN it should combine baseUrl and endpoint correctly',
        () {
          // Arrange
          const id = 25;

          // Act
          final fullUrl =
              '${ApiConstants.baseUrl}${ApiConstants.pokemonById(id)}';

          // Assert
          expect(fullUrl, 'https://pokeapi.co/api/v2/pokemon/25');
        },
      );

      test(
        'GIVEN ApiConstants WHEN building list URL THEN it should include pagination query params',
        () {
          // Arrange
          const limit = ApiConstants.defaultLimit;
          const offset = 0;

          // Act
          const listUrl =
              '${ApiConstants.baseUrl}${ApiConstants.pokemon}?limit=$limit&offset=$offset';

          // Assert
          expect(
            listUrl,
            'https://pokeapi.co/api/v2/pokemon?limit=20&offset=0',
          );
        },
      );
    });
  });
}
