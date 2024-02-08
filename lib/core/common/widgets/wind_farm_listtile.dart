import 'package:flutter/material.dart';

class CustomListTileWindFarm extends StatelessWidget {
  const CustomListTileWindFarm({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            data,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
