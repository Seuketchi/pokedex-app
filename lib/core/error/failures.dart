import 'package:equatable/equatable.dart';

// return expected error states that the UI can handle gracefully
abstract class Failure extends Equatable {

  const Failure({this.message});
  final String? message;

  @override
  List<Object?> get props => [message];
}

// failure when the API returns an error response
class ServerFailure extends Failure {
  const ServerFailure({super.message, this.statusCode});
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

// failure when a local storage operation fails
class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

// failure when there is no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}
