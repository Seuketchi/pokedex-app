import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/error/exceptions.dart';
import 'package:pokedex_app/core/network/dio_client.dart';

// NOTE:
// These tests are different from typical Flutter widget tests.
// They are pure unit tests for the DioClient error transformation logic.
// Each test verifies that a specific DioException type or response status code
// correctly maps to a custom exception (NetworkException or ServerException),
// ensuring that the app can handle errors gracefully.

void main() {
  group('DioClient Error Transformation', () {
    late RequestOptions requestOptions;

    setUp(() {
      requestOptions = RequestOptions(path: '/test');
    });

    group(
      'GIVEN DioException of network type WHEN transformed THEN returns NetworkException',
      () {
        test(
          'GIVEN connectionError WHEN transformed THEN returns NetworkException with message "Connection failed"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.connectionError,
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<NetworkException>());
            expect(
              (exception as NetworkException).message,
              'Connection failed',
            );
          },
        );

        test(
          'GIVEN connectionTimeout WHEN transformed THEN returns NetworkException with message "Connection failed"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.connectionTimeout,
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<NetworkException>());
            expect(
              (exception as NetworkException).message,
              'Connection failed',
            );
          },
        );

        test(
          'GIVEN sendTimeout WHEN transformed THEN returns NetworkException with message "Send timeout"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.sendTimeout,
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<NetworkException>());
            expect((exception as NetworkException).message, 'Send timeout');
          },
        );

        test(
          'GIVEN receiveTimeout WHEN transformed THEN returns NetworkException with message "Receive timeout"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.receiveTimeout,
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<NetworkException>());
            expect((exception as NetworkException).message, 'Receive timeout');
          },
        );

        test(
          'GIVEN unknown with SocketException WHEN transformed THEN returns NetworkException with message "No internet connection"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              message: 'SocketException: Connection refused',
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<NetworkException>());
            expect(
              (exception as NetworkException).message,
              'No internet connection',
            );
          },
        );
      },
    );

    group(
      'GIVEN DioException of badResponse WHEN transformed THEN returns ServerException',
      () {
        test(
          'GIVEN 400 Bad Request WHEN transformed THEN returns ServerException with statusCode 400 and message "Bad request"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: requestOptions,
                statusCode: 400,
              ),
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<ServerException>());
            expect((exception as ServerException).statusCode, 400);
            expect(exception.message, 'Bad request');
          },
        );

        test(
          'GIVEN 404 Not Found WHEN transformed THEN returns ServerException with statusCode 404 and message "Not found"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: requestOptions,
                statusCode: 404,
              ),
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<ServerException>());
            expect((exception as ServerException).statusCode, 404);
            expect(exception.message, 'Not found');
          },
        );

        test(
          'GIVEN 500 Internal Server Error WHEN transformed THEN returns ServerException with statusCode 500 and message "Internal server error"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: requestOptions,
                statusCode: 500,
              ),
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<ServerException>());
            expect((exception as ServerException).statusCode, 500);
            expect(exception.message, 'Internal server error');
          },
        );

        test(
          'GIVEN response body with message field WHEN transformed THEN extracts custom error message',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: requestOptions,
                statusCode: 400,
                data: {'message': 'Invalid Pokemon ID'},
              ),
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<ServerException>());
            expect(
              (exception as ServerException).message,
              'Invalid Pokemon ID',
            );
          },
        );

        test(
          'GIVEN response body with error field WHEN transformed THEN extracts custom error message',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: requestOptions,
                statusCode: 400,
                data: {'error': 'Pokemon not found'},
              ),
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<ServerException>());
            expect((exception as ServerException).message, 'Pokemon not found');
          },
        );
      },
    );

    group(
      'GIVEN other DioException types WHEN transformed THEN returns appropriate Exception',
      () {
        test(
          'GIVEN cancel WHEN transformed THEN returns NetworkException with message "Request cancelled"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.cancel,
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<NetworkException>());
            expect(
              (exception as NetworkException).message,
              'Request cancelled',
            );
          },
        );

        test(
          'GIVEN badCertificate WHEN transformed THEN returns ServerException with message "Bad certificate"',
          () {
            // Arrange
            final dioError = DioException(
              requestOptions: requestOptions,
              type: DioExceptionType.badCertificate,
            );

            // Act
            final exception = DioClient.transformError(dioError);

            // Assert
            expect(exception, isA<ServerException>());
            expect((exception as ServerException).message, 'Bad certificate');
          },
        );
      },
    );
  });
}
