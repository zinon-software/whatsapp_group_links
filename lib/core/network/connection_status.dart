import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectionStatus {
  Future<bool> get isConnected;

  Future<bool> get isNotConnected;

  Stream<ConnectionEnum> get internetStream;

  void dispose();
}

class InternetConnectionStatus implements ConnectionStatus {
  final Connectivity _checker;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late StreamController<ConnectionEnum> _internetStreamController;

  InternetConnectionStatus({required Connectivity checker})
      : _checker = checker {
    _internetStreamController = StreamController<ConnectionEnum>.broadcast();
    _connectivitySubscription =
        _checker.onConnectivityChanged.listen((List<ConnectivityResult> event) {
      _updateConnectionStatus(event);
    });
  }

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult =
        await _checker.checkConnectivity();
    return _isConnected(connectivityResult);
  }

  @override
  Future<bool> get isNotConnected async {
    final List<ConnectivityResult> connectivityResult =
        await _checker.checkConnectivity();
    return !_isConnected(connectivityResult);
  }

  bool _isConnected(List<ConnectivityResult> connectivityResult) {
    return connectivityResult.isNotEmpty &&
            connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn) ||
        connectivityResult.contains(ConnectivityResult.bluetooth) ||
        connectivityResult.contains(ConnectivityResult.other);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _internetStreamController.close();
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (_isConnected(connectivityResult)) {
      _internetStreamController.add(ConnectionEnum.connected);
    } else {
      _internetStreamController.add(ConnectionEnum.disconnected);
    }
  }

  @override
  Stream<ConnectionEnum> get internetStream => _internetStreamController.stream;
}

enum ConnectionEnum { waiting, disconnected, connected, none }
