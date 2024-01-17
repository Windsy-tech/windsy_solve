import 'package:flutter/material.dart';
import 'package:windsy_solve/features/nc/widgets/nc_assign.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

class AddNCActionTaken extends StatefulWidget {
  const AddNCActionTaken({Key? key}) : super(key: key);

  @override
  State<AddNCActionTaken> createState() => _AddNCActionTakenState();
}

class _AddNCActionTakenState extends State<AddNCActionTaken> {
  DateTime pickedDateTime = DateTime.now();

  void showDateTimePicker() {
    showDatePicker(
      context: context,
      initialDate: pickedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    ).then((value) {
      if (value != null) {
        setState(() {
          pickedDateTime = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Action')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Action"),
              const SizedBox(height: 4),
              const TextField(
                maxLength: 50,
              ),
              const SizedBox(height: 8),
              const Text("Description"),
              const SizedBox(height: 4),
              const TextField(
                maxLines: 4,
              ),
              const SizedBox(height: 8),
              ListTile(
                onTap: () => showDateTimePicker(),
                contentPadding: const EdgeInsets.all(0),
                leading: const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                ),
                title: const Text(
                  "Due Date",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: Text(
                  pickedDateTime.toDateString(),
                  style: TextStyle(
                    color: pickedDateTime.isBefore(
                      DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                    )
                        ? Colors.red
                        : null,
                  ),
                ),
              ),
              //NCAssign(ref: ref, onAssign: onAssign),
            ],
          ),
        ),
      ),
    );
  }
}
