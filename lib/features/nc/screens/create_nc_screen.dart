import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/features/nc/screens/nc_add_actions_taken_screen.dart';
import 'package:windsy_solve/features/nc/widgets/nc_assign.dart';
import 'package:windsy_solve/features/nc/widgets/nc_wind_farm.dart';
import 'package:windsy_solve/models/nc_model.dart';
import 'package:windsy_solve/models/windfarm_model.dart';

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
  WindFarmModel windFarm = WindFarmModel();

  void createNC() async {
    final user = ref.read(userProvider);
    print(user!.uid);
    ref.read(ncControllerProvider.notifier).createNC(
          context,
          NCModel(
            id: '',
            title: titleController.text,
            problemDescription: problemDescriptionController.text,
            status: status,
            severity: severities.indexOf(severity),
            category: '',
            windFarm: windFarm.windFarm!,
            turbineNo: windFarm.turbineNo!,
            platform: windFarm.platform!,
            oem: windFarm.oem!,
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
  void dispose() {
    titleController.dispose();
    problemDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report NC'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton(
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
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton(
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
                  },
                ),
                const SizedBox(height: 8),
                NCWindFarm(
                  onSelected: (windFarm) {
                    setState(() {
                      this.windFarm = windFarm;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Actions Taken'),
                        IconButton(
                          onPressed: () {
                            Routemaster.of(context).push(
                              'add-action-taken',
                            );
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => createNC(),
                  child: const Text('Create NC'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
