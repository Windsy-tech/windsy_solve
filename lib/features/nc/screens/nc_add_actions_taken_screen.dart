import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/nc/controller/nc_actions_controller.dart';
import 'package:windsy_solve/models/nc_actions_model.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

class AddNCActionTaken extends ConsumerStatefulWidget {
  final String ncId;
  const AddNCActionTaken({super.key, required this.ncId});

  @override
  ConsumerState<AddNCActionTaken> createState() => _AddNCActionTakenState();
}

class _AddNCActionTakenState extends ConsumerState<AddNCActionTaken> {
  final _actionsController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime pickedDateTime;

  @override
  void initState() {
    super.initState();
    pickedDateTime = DateTime.now();
  }

  @override
  void dispose() {
    _actionsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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

  void addActionTaken(String ncId) {
    ref.read(ncActionsControllerProvider).addAction(
          context,
          ncId,
          NCActionsModel(
            id: '',
            action: '',
            description: '',
            dueDate: '',
            status: '',
            createdBy: '',
            createdAt: '',
            completedBy: '',
            completedAt: '',
            assignedTo: [],
            comments: [],
          ),
        );
  }

  void addAction() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Action'),
        actions: [
          IconButton(
            onPressed: () => addActionTaken(widget.ncId),
            icon: const Icon(Icons.add),
          )
        ],
      ),
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
