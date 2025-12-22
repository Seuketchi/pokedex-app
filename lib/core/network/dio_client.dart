import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex_app/core/constants/api_constants.dart';
import 'package:pokedex_app/core/error/exceptions.dart';

@module
abstract class DioModule {
  @LazySingleton()
  Dio get dio => DioClient.createDio();
}

abstract class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // You can add interceptors or other configurations here if needed.
    dio.interceptors.addAll([
      _errorInterceptor(),
      if (kDebugMode) _loggingInterceptor(),
    ]);
    return dio;
  }

  static Interceptor _loggingInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseHeader: false,
      logPrint: (message) => debugPrint('$message'),
    );
  }

  static Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        final exception = transformError(error);
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: exception,
            type: error.type,
            response: error.response,
          ),
        );
      },
    );
  }

  @visibleForTesting
  static Exception transformError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return const NetworkException(message: 'Connection failed');
      case DioExceptionType.sendTimeout:
        return const NetworkException(message: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Receive timeout');
      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Bad certificate');
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return const NetworkException(message: 'Request cancelled');
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return const NetworkException();
        }
        return ServerException(message: error.message);
    }
  }

  static Exception _handleBadResponse(Response<dynamic>? response) {
    final statusCode = response?.statusCode;
    final message = _extractErrorMessage(response);

    switch (statusCode) {
      case 400:
        return ServerException(
          message: message ?? 'Bad request',
          statusCode: 400,
        );
      case 401:
        return ServerException(
          message: message ?? 'Unauthorized',
          statusCode: 401,
        );
      case 403:
        return ServerException(
          message: message ?? 'Forbidden',
          statusCode: 403,
        );
      case 404:
        return ServerException(
          message: message ?? 'Not found',
          statusCode: 404,
        );
      case 429:
        return ServerException(
          message: message ?? 'Too many requests',
          statusCode: 429,
        );
      case 500:
        return ServerException(
          message: message ?? 'Internal server error',
          statusCode: 500,
        );
      case 502:
        return ServerException(
          message: message ?? 'Bad gateway',
          statusCode: 502,
        );
      case 503:
        return ServerException(
          message: message ?? 'Service unavailable',
          statusCode: 503,
        );
      default:
        return ServerException(
          message: message ?? 'Server error',
          statusCode: statusCode,
        );
    }
  }

  static String? _extractErrorMessage(Response<dynamic>? response) {
    try {
      final data = response?.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ??
            data['error'] as String? ??
            data['detail'] as String?;
      }
      return null;
    } on Object {
      return null;
    }
  }
}
