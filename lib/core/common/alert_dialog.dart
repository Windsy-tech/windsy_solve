import 'package:flutter/material.dart';

//show alert dialog
Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String defaultActionText,
}) async {
  final theme = Theme.of(context);
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title, style: theme.textTheme.labelLarge),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                content,
                style: theme.textTheme.labelLarge,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              //TODO: implement cancel action
              Navigator.of(dialogContext, rootNavigator: true).pop('dialog');
            },
            child: Text(
              'Cancel',
              style: theme.textTheme.labelMedium,
            ),
          ),
          TextButton(
            child: Text(
              defaultActionText,
              style: theme.textTheme.labelMedium,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
