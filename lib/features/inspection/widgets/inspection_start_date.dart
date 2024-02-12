import 'package:flutter/material.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

class InspectionStartDate extends StatelessWidget {
  final DateTime startDate;
  final ValueChanged<DateTime?>? onChanged;
  const InspectionStartDate({
    super.key,
    required this.startDate,
    this.onChanged,
  });

  Future<DateTime?> showDateTimePicker(BuildContext context) {
    print(startDate);
    return showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: const LabelWidget(
        'Start date'
      ),
      trailing: TextButton(
        onPressed: () async {
          final dateTime = await showDateTimePicker(context);
          onChanged?.call(dateTime);
        },
        child: Text(
          startDate.toDateString(),
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
