import 'package:connectivity_plus/connectivity_plus.dart';

abstract class INetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfo implements INetworkInfo {
  final Connectivity connectivity;
  NetworkInfo({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    // connectivity_plus >=6 returns List<ConnectivityResult>
    if (result is List<ConnectivityResult>) {
      return !result.contains(ConnectivityResult.none);
    }
    // Fallback for older versions returning a single ConnectivityResult
    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }
    return false;
  }
}
