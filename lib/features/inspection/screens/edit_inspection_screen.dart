import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/core/common/warning_alert.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_end_date.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_section.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_start_date.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_wind_farm.dart';
import 'package:windsy_solve/models/inspection_model.dart';
import 'package:windsy_solve/models/windfarm_model.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class EditInspectionScreen extends ConsumerStatefulWidget {
  final String inspectionId;
  const EditInspectionScreen({required this.inspectionId, super.key});
  @override
  ConsumerState<EditInspectionScreen> createState() =>
      _CreateConsumerEditInspectionScreenState();
}

class _CreateConsumerEditInspectionScreenState
    extends ConsumerState<EditInspectionScreen> {
  final titleController = TextEditingController();
  final problemDescriptionController = TextEditingController();
  List<String> severities = ['Low', 'Medium', 'High'];
  List<String> statuses = ['Open', 'Closed'];
  String severity = '';
  String status = '';
  List<String> assignedTo = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  InspectionModel inspectionModel = InspectionModel(
    id: '',
    title: '',
    problemDescription: '',
    severity: 0,
    status: '',
    windFarm: "",
    assignedTo: [],
    category: '',
    customer: '',
    externalAuditor: '',
    supplier: '',
    createdAt: DateTime.now(),
    closedAt: DateTime.now(),
    turbineNo: '',
    createdBy: '',
    updatedBy: '',
    updatedAt: DateTime.now(),
  );

  WindFarmModel windFarm = WindFarmModel(
    windFarm: '',
    platform: '',
    oem: '',
    turbineNo: '',
  );

  void updateInspection() async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return ref.watch(getInspectionbyIdProvider(widget.inspectionId)).when(
          data: (inspection) {
            if (inspectionModel.id == "") {
              inspectionModel = inspection;
              print(inspectionModel.toString());
              titleController.text = inspection.title;
              problemDescriptionController.text = inspection.problemDescription;
              status = inspection.status;
              severity = severities[inspection.severity];
              assignedTo = inspection.assignedTo!;
              windFarm = WindFarmModel(
                windFarm: inspection.windFarm,
                platform: inspection.platform,
                oem: inspection.oem,
                turbineNo: inspection.turbineNo,
              );
            }
            return Scaffold(
              backgroundColor: theme.colorScheme.background,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Text('Inspection - ${inspection.id}'),
                leading: IconButton(
                  onPressed: () async {
                    await showWarningExitAlert(context);
                  },
                  icon: const Icon(Icons.close_outlined),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: updateInspection,
                    icon: const Icon(Icons.save),
                  ),
                ],
              ),
              body: Container(
                height: size.height,
                decoration: BoxDecoration(
                  gradient: theme.brightness == Brightness.dark
                      ? ColorPalette.darkSurface
                      : ColorPalette.lightSurface,
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const LabelWidget('Title'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              hintText: 'Enter Title',
                            ),
                          ),
                          const SizedBox(height: 8),
                          InspectionStartDate(
                            startDate: startDate,
                            onChanged: (date) {
                              setState(() {
                                startDate = date!;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          InspectionEndDate(endDate: endDate),
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
                            leading: const LabelWidget('Status'),
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
                                onChanged: (value) =>
                                    setState(() => status = value!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: const LabelWidget('Severity'),
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
                                onChanged: (value) =>
                                    setState(() => severity = value!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InspectionSection(
                            inspectionId: inspectionModel.id,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          error: (e, s) => ErrorText(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}
