import 'package:flutter/material.dart';

//Created by, modified by name and date

class CreatedModifiedBy extends StatelessWidget {
  final String createdBy;
  final DateTime createdAt;
  final String modifiedBy;
  final DateTime modifiedAt;
  const CreatedModifiedBy({
    super.key,
    required this.createdBy,
    required this.createdAt,
    required this.modifiedBy,
    required this.modifiedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Created by $createdBy on $createdAt',
            style: theme.textTheme.labelSmall,
          ),
          Text(
            'Last updated by $modifiedBy on $modifiedAt',
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
