import 'package:flutter/material.dart';

class HomeActions extends StatelessWidget {
  const HomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DataTable(
      columns: const [
        DataColumn(
          label: Text('Action'),
        ),
        DataColumn(
          label: Text('Assinged By'),
        ),
        DataColumn(
          label: Text(''),
        ),
      ],
      rows: const [
        DataRow(
          cells: [
            DataCell(
              Text('Open Tasks'),
            ),
            DataCell(
              Text('Felix Wernicke'),
            ),
            DataCell(
              Text('NC'),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Text('Open Tasks'),
            ),
            DataCell(
              Text('Felix Wernicke'),
            ),
            DataCell(
              Text('NC'),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              Text('Open Tasks'),
            ),
            DataCell(
              Text('Felix Wernicke'),
            ),
            DataCell(
              Text('Inspection'),
            ),
          ],
        ),
      ],
    );
  }
}
