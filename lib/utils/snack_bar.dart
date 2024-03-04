import 'package:flutter/material.dart';

enum SnackBarType {
  success,
  error,
  warning,
}

void showSnackBar(BuildContext context, String message, SnackBarType type) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar(reason: SnackBarClosedReason.timeout)
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: type == SnackBarType.success
            ? Colors.green
            : type == SnackBarType.error
                ? Colors.red
                : Colors.orange,
        duration: const Duration(seconds: 3),
        showCloseIcon: true,
      ),
    );
}
