import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  // Checks if the device is connected to the internet.
  Future<bool> get isConnected;
}

@lazySingleton
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectionChecker);

  final Connectivity connectionChecker;

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectionChecker.checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
