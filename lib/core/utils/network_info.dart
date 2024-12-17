import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class INetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfo implements INetworkInfo {
  final InternetConnection connectionChecker;

  const NetworkInfo({required this.connectionChecker});

  @override
  Future<bool> get isConnected async => connectionChecker.hasInternetAccess;
}
