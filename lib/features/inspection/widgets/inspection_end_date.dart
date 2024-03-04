import 'package:flutter/material.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

class InspectionEndDate extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime?>? onChanged;
  const InspectionEndDate({
    super.key,
    required this.startDate,
    required this.endDate,
    this.onChanged,
  });

  Future<DateTime?> showDateTimePicker(BuildContext context) {
    final theme = Theme.of(context);
    return showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2300),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) => Theme(
        data: theme.copyWith(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ),
        child: child!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: const LabelWidget('End date'),
      trailing: TextButton(
        onPressed: () async {
          final dateTime = await showDateTimePicker(context);
          if (dateTime == null) {
            return;
          } else {
            if (dateTime.isAfter(startDate) ||
                dateTime.isAtSameMomentAs(startDate)) {
              onChanged?.call(endDate);
            }
          }
        },
        child: Text(
          endDate.toDateString(),
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
