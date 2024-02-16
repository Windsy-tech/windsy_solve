import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityStatus extends StatefulWidget {
  const ConnectivityStatus({super.key});

  @override
  State<ConnectivityStatus> createState() => _ConnectivityStatusState();
}

class _ConnectivityStatusState extends State<ConnectivityStatus> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = ConnectivityResult.none;
    }

    if (!mounted) {
      return Future.value(null);
    }

    setState(() {
      _connectivityResult = result;
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _connectivityResult == ConnectivityResult.none
          ? 'No Internet Connection'
          : 'Internet Connected',
      onPressed: () {},
      icon: Icon(
        _connectivityResult == ConnectivityResult.none
            ? Icons.wifi_off
            : Icons.wifi,
        color: _connectivityResult == ConnectivityResult.none
            ? Colors.red
            : Colors.green,
      ),
    );
  }
}
