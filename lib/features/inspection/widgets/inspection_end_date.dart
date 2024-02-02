import 'package:flutter/material.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

class InspectionEndDate extends StatelessWidget {
  final DateTime endDate;
  final ValueChanged<DateTime?>? onChanged;
  const InspectionEndDate({
    super.key,
    required this.endDate,
    this.onChanged,
  });

  Future<DateTime?> showDateTimePicker(BuildContext context) {
    print(endDate);
    return showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: const Text(
        'End date',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      trailing: TextButton(
        onPressed: () async {
          final dateTime = await showDateTimePicker(context);
          onChanged?.call(dateTime);
        },
        child: Text(
          endDate.toDateString(),
        ),
      ),
    );
  }
}