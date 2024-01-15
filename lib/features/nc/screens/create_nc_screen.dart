import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/features/nc/screens/nc_assign.dart';
import 'package:windsy_solve/features/settings/user_profile/controller/user_profile_controller.dart';
import 'package:windsy_solve/models/nc_model.dart';

class ReportNC extends ConsumerStatefulWidget {
  const ReportNC({Key? key}) : super(key: key);
  static const routeName = '/non-conformity';

  @override
  ConsumerState<ReportNC> createState() => _CreateConsumerReportNCState();
}

class _CreateConsumerReportNCState extends ConsumerState<ReportNC> {
  final titleController = TextEditingController();
  final problemDescriptionController = TextEditingController();
  List<String> severities = ['Low', 'Medium', 'High'];
  List<String> statuses = ['Open', 'Closed'];
  String status = 'Open';
  String severity = 'Low';
  List<String> assignedTo = [];

  void createNC() async {
    final user = ref.read(userProvider);
    ref.read(ncControllerProvider.notifier).createNC(
          context,
          NCModel(
            id: '',
            title: titleController.text,
            problemDescription: problemDescriptionController.text,
            status: status,
            severity: severities.indexOf(severity),
            category: '',
            windFarm: '',
            turbineNo: '',
            platform: '',
            oem: '',
            createdBy: user!.uid,
            assignedTo: assignedTo,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            closedAt: DateTime(0),
            closedBy: '',
            closedReason: '',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report NC'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title"),
              const SizedBox(height: 4),
              const TextField(
                maxLength: 50,
              ),
              const SizedBox(height: 8),
              const Text("Problem Description"),
              const SizedBox(height: 4),
              const TextField(
                maxLines: 4,
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                contentPadding: const EdgeInsets.all(0),
                trailing: DropdownButton(
                  value: status,
                  items: statuses
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => status = value!),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const Text(
                  'Severity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: DropdownButton(
                  value: severity,
                  items: severities
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => severity = value!),
                ),
              ),
              const SizedBox(height: 8),
              /* const Text('Wind Farm'),
              const SizedBox(height: 4),
              const SizedBox(height: 8), */
              const SizedBox(height: 8),
              NCAssign(
                  ref: ref,
                  onAssign: (assignedTo) {
                    setState(() {
                      this.assignedTo = assignedTo.toList();
                    });
                  }),
              ElevatedButton(
                onPressed: () => createNC(),
                child: const Text('Create NC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
