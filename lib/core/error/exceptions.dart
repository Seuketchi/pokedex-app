// Thrown when the API returns a response with an error status code.
class ServerException implements Exception {
  const ServerException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

/// Thrown when a local storage operation fails.
class CacheException implements Exception {
  const CacheException({this.message});

  final String? message;

  @override
  String toString() => 'CacheException: $message';
}

// Thrown when there is no internet connection.
class NetworkException implements Exception {
  const NetworkException({this.message = 'No internet connection'});

  final String? message;

  @override
  String toString() => 'NetworkException: $message';
}
