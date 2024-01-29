import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_section.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_wind_farm.dart';
import 'package:windsy_solve/models/inspection_model.dart';
import 'package:windsy_solve/models/windfarm_model.dart';

class PerformInspectionScreen extends ConsumerStatefulWidget {
  final String type;
  final String templateName;
  const PerformInspectionScreen({
    required this.type,
    required this.templateName,
    super.key,
  });
  @override
  ConsumerState<PerformInspectionScreen> createState() =>
      _CreateConsumerPerformInspectionScreenState();
}

class _CreateConsumerPerformInspectionScreenState
    extends ConsumerState<PerformInspectionScreen> {
  final titleController = TextEditingController();
  final externalAuditorController = TextEditingController();
  final supplierController = TextEditingController();
  final customerController = TextEditingController();

  List<String> severities = ['Low', 'Medium', 'High'];
  List<String> statuses = ['Open', 'Closed'];
  String status = 'Open';
  String severity = 'Low';
  List<String> assignedTo = [];
  WindFarmModel windFarm = WindFarmModel();

  void createInspection() {
    final user = ref.read(userProvider)!;
    ref.read(inspectionControllerProvider.notifier).createNC(
          context,
          user.companyId,
          InspectionModel(
            id: '',
            title: titleController.text,
            problemDescription: "",
            externalAuditor: externalAuditorController.text,
            supplier: supplierController.text,
            customer: customerController.text,
            category: '',
            status: status,
            severity: severities.indexOf(severity),
            windFarm: windFarm.windFarm!,
            turbineNo: windFarm.turbineNo!,
            platform: windFarm.platform!,
            oem: windFarm.oem!,
            createdBy: user.uid,
            createdAt: DateTime.now(),
            updatedBy: user.uid,
            updatedAt: DateTime.now(),
            closedAt: DateTime.now(),
            closedBy: '',
            closedReason: '',
          ),
        );
  }

  @override
  void dispose() {
    titleController.dispose();
    externalAuditorController.dispose();
    supplierController.dispose();
    customerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perform Inspection"),
        actions: [
          IconButton(
            onPressed: () {
              createInspection();
            },
            icon: const Icon(Icons.save),
          ),
        ],
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
                TextField(
                  controller: titleController,
                  maxLength: 50,
                ),
                const SizedBox(height: 8),
                const ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Text(
                    'Start date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InspectionWindFarm(
                  null,
                  onSelected: (windFarm) {
                    setState(() {
                      this.windFarm = windFarm;
                    });
                  },
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
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
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
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => severity = value!),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const InspectionSection(
                  inspectionId: 'I-1001',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
