import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus {
  wifi,
  mobile,
  offline,
}

final connectivityProvider = Provider((ref) => ConnectivityProvider());

class ConnectivityProvider {
  final Connectivity _connectivity = Connectivity();

  Future<ConnectivityStatus> get connectivityStatus async {
    try {
      final result = await _connectivity.checkConnectivity();
      switch (result) {
        case ConnectivityResult.wifi:
          return ConnectivityStatus.wifi;
        case ConnectivityResult.mobile:
          return ConnectivityStatus.mobile;
        case ConnectivityResult.none:
          return ConnectivityStatus.offline;
        default:
          return ConnectivityStatus.offline;
      }
    } catch (e) {
      // Handle exception, e.g., log or return a default status
      return ConnectivityStatus.offline;
    }
  }
}
