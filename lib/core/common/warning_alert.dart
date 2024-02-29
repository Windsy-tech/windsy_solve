import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/alert_dialog.dart';

Future showWarningExitAlert(BuildContext context) async {
  await showAlertDialog(
    context: context,
    title: 'Warning',
    content: 'Are you sure you want to exit?',
    defaultActionText: 'Yes',
  );
  if (context.mounted) {
    Routemaster.of(context).history.back();
  }
}

Future showWarningSaveAlertDialog(BuildContext context) {
  final theme = Theme.of(context);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.yellow),
        title: Text(
          "Warning!",
          style: theme.textTheme.headlineLarge,
        ),
        content: Text(
          "Inorder to create a section, you need to save the inspection first",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //saveInspection();
            },
            child: Text(
              "OK",
              style: theme.textTheme.labelMedium,
            ),
          ),
        ],
      );
    },
  );
}
