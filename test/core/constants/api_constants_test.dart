import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/constants/api_constants.dart';

void main() {
  group('ApiConstants', () {
    test(
      'GIVEN ApiConstants '
      'WHEN accessing baseUrl '
      'THEN it should match the expected value',
      () {
        // Act & Assert
        expect(ApiConstants.baseUrl, 'https://pokeapi.co/api/v2');
      },
    );

    test(
      'GIVEN ApiConstants '
      'WHEN accessing timeout values '
      'THEN they should all be set to 30000',
      () {
        // Act & Assert
        expect(ApiConstants.connectTimeout, 30000);
        expect(ApiConstants.receiveTimeout, 30000);
        expect(ApiConstants.sendTimeout, 30000);
      },
    );

    test(
      'GIVEN ApiConstants '
      'WHEN accessing defaultLimit '
      'THEN it should be 20',
      () {
        // Act & Assert
        expect(ApiConstants.defaultLimit, 20);
      },
    );
  });
}
