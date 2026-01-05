import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/usecases/usecase.dart';

void main() {
  group('NoReturn', () {
    test('should return the same singleton instance', () {
      // arrange & act
      final instance1 = NoReturn();
      final instance2 = NoReturn();

      // assert
      expect(instance1, equals(instance2));
      expect(identical(instance1, instance2), isTrue);
    });

    test('should create singleton through private constructor', () {
      // arrange & act
      final instance = NoReturn();

      // assert
      expect(instance, isA<NoReturn>());
      expect(instance, isNotNull);
    });
  });

  group('NoParams', () {
    test('should create NoParams instance', () {
      // arrange & act
      const params = NoParams();

      // assert
      expect(params, isA<NoParams>());
      expect(params, isNotNull);
    });

    test('should support equality comparison', () {
      // arrange
      const params1 = NoParams();
      const params2 = NoParams();

      // assert
      expect(params1, equals(params2));
    });

    test('should work with const constructor', () {
      // arrange & act
      const params1 = NoParams();
      const params2 = NoParams();

      // assert
      expect(identical(params1, params2), isTrue);
    });
  });
}
