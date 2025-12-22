import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/error/failures.dart';

/// NOTE:
/// These tests are written for Exception and Failure classes, which are
/// essentially immutable data holders. Unlike typical Flutter tests that
/// interact with widgets, services, or dependencies, these tests:
///
/// 1. Verify that constructor fields store values correctly.
/// 2. Ensure `toString()` formatting behaves as expected.
/// 3. Check equality via `Equatable` (`props`) for proper comparison.
///
/// These tests are mostly "property tests" to protect against accidental
/// changes in your error/failure classes. They may seem trivial, but they
/// act as **regression protection** and document the expected behavior.

void main() {
  group('Exceptions', () {
    group('ServerException', () {
      test(
        'GIVEN a ServerException with message and statusCode WHEN accessing properties THEN returns correct values',
        () {
          // Arrange & Act
          const exception = ServerException(
            message: 'Not found',
            statusCode: 404,
          );

          // Assert
          expect(exception.message, 'Not found');
          expect(exception.statusCode, 404);
        },
      );

      test(
        'GIVEN a ServerException WHEN calling toString THEN returns formatted string',
        () {
          // Arrange
          const exception = ServerException(
            message: 'Server error',
            statusCode: 500,
          );

          // Act
          final result = exception.toString();

          // Assert
          expect(result, contains('ServerException'));
          expect(result, contains('500'));
        },
      );

      test(
        'GIVEN a ServerException with null values WHEN accessing properties THEN returns null',
        () {
          // Arrange & Act
          const exception = ServerException();

          // Assert
          expect(exception.message, isNull);
          expect(exception.statusCode, isNull);
        },
      );
    });

    group('NetworkException', () {
      test(
        'GIVEN a NetworkException with default message THEN message is correct',
        () {
          // Arrange & Act
          const exception = NetworkException();

          // Assert
          expect(exception.message, 'No internet connection');
        },
      );

      test(
        'GIVEN a NetworkException with custom message THEN message is correct',
        () {
          // Arrange & Act
          const exception = NetworkException(message: 'Timeout');

          // Assert
          expect(exception.message, 'Timeout');
        },
      );

      test(
        'GIVEN a NetworkException WHEN calling toString THEN returns formatted string',
        () {
          // Arrange
          const exception = NetworkException(message: 'Offline');

          // Act
          final result = exception.toString();

          // Assert
          expect(result, contains('NetworkException'));
          expect(result, contains('Offline'));
        },
      );
    });

    group('CacheException', () {
      test(
        'GIVEN a CacheException with message THEN message is correct',
        () {
          // Arrange & Act
          const exception = CacheException(message: 'Cache miss');

          // Assert
          expect(exception.message, 'Cache miss');
        },
      );

      test(
        'GIVEN a CacheException WHEN calling toString THEN returns formatted string',
        () {
          // Arrange
          const exception = CacheException(message: 'Cache miss');

          // Act
          final result = exception.toString();

          // Assert
          expect(result, contains('CacheException'));
          expect(result, contains('Cache miss'));
        },
      );
    });
  });

  group('Failures', () {
    group('ServerFailure', () {
      test(
        'GIVEN a ServerFailure with message and statusCode THEN props return correct values',
        () {
          // Arrange & Act
          const failure = ServerFailure(
            message: 'Internal error',
            statusCode: 500,
          );

          // Assert
          expect(failure.props, ['Internal error', 500]);
        },
      );

      test(
        'GIVEN two ServerFailures with same properties THEN they are equal',
        () {
          // Arrange
          const f1 = ServerFailure(message: 'Error', statusCode: 500);
          const f2 = ServerFailure(message: 'Error', statusCode: 500);

          // Act & Assert
          expect(f1, equals(f2));
        },
      );

      test(
        'GIVEN two ServerFailures with different properties THEN they are not equal',
        () {
          // Arrange
          const f1 = ServerFailure(message: 'Error', statusCode: 500);
          const f2 = ServerFailure(message: 'Error', statusCode: 404);

          // Act & Assert
          expect(f1, isNot(equals(f2)));
        },
      );
    });

    group('NetworkFailure', () {
      test(
        'GIVEN a NetworkFailure with default message THEN message is correct',
        () {
          // Arrange & Act
          const failure = NetworkFailure();

          // Assert
          expect(failure.message, 'No internet connection');
        },
      );

      test(
        'GIVEN two NetworkFailures with same message THEN they are equal',
        () {
          // Arrange
          const f1 = NetworkFailure();
          const f2 = NetworkFailure();

          // Act & Assert
          expect(f1, equals(f2));
        },
      );
    });

    group('CacheFailure', () {
      test(
        'GIVEN a CacheFailure with message THEN message is correct',
        () {
          // Arrange & Act
          const failure = CacheFailure(message: 'Cache failed');

          // Assert
          expect(failure.message, 'Cache failed');
        },
      );

      test(
        'GIVEN two CacheFailures with same message THEN they are equal',
        () {
          // Arrange
          const f1 = CacheFailure(message: 'Cache error');
          const f2 = CacheFailure(message: 'Cache error');

          // Act & Assert
          expect(f1, equals(f2));
        },
      );
    });
  });
}
