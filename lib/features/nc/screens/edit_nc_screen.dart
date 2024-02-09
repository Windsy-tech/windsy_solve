import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/alert_dialog.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/features/nc/widgets/nc_assign.dart';
import 'package:windsy_solve/features/nc/widgets/nc_attachments.dart';
import 'package:windsy_solve/features/nc/widgets/nc_wind_farm.dart';
import 'package:windsy_solve/models/nc_model.dart';
import 'package:windsy_solve/models/windfarm_model.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class NCEditScreen extends ConsumerStatefulWidget {
  final String ncId;
  const NCEditScreen(this.ncId, {super.key});
  @override
  ConsumerState<NCEditScreen> createState() =>
      _CreateConsumerNCEditScreenState();
}

class _CreateConsumerNCEditScreenState extends ConsumerState<NCEditScreen> {
  final titleController = TextEditingController();
  final problemDescriptionController = TextEditingController();
  List<String> severities = ['Low', 'Medium', 'High'];
  List<String> statuses = ['Open', 'Closed'];
  String severity = '';
  String status = '';
  List<String> assignedTo = [];
  NCModel ncModel = NCModel(
    id: '',
    title: '',
    problemDescription: '',
    severity: 0,
    status: '',
    windFarm: "",
    assignedTo: [],
    category: '',
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

  @override
  void dispose() {
    titleController.dispose();
    problemDescriptionController.dispose();
    super.dispose();
  }

  void updateNC() async {
    final user = ref.read(userProvider)!;
    ref.read(ncControllerProvider.notifier).updateNC(
          context,
          NCModel(
            id: ncModel.id,
            title: titleController.text,
            problemDescription: problemDescriptionController.text,
            status: status,
            severity: severities.indexOf(severity),
            category: '',
            windFarm: windFarm.windFarm!,
            turbineNo: windFarm.turbineNo!,
            platform: windFarm.platform!,
            oem: windFarm.oem,
            assignedTo: assignedTo,
            createdBy: ncModel.createdBy,
            createdAt: ncModel.createdAt,
            updatedBy: user.uid,
            updatedAt: DateTime.now(),
            closedBy: ncModel.closedBy,
            closedAt: ncModel.closedAt,
            closedReason: ncModel.closedReason,
          ),
        );
  }

  Future showAlert(BuildContext context) async {
    await showAlertDialog(
      context: context,
      title: 'Warning',
      content: 'Are you sure you want to exit?',
      defaultActionText: 'Yes',
    );
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return ref.watch(getNCbyIdProvider(widget.ncId)).when(
          data: (nc) {
            if (ncModel.id == "") {
              ncModel = nc;
              titleController.text = ncModel.title;
              problemDescriptionController.text = ncModel.problemDescription;
              status = ncModel.status;
              severity = severities[ncModel.severity];
              assignedTo = ncModel.assignedTo!;
              windFarm = WindFarmModel(
                windFarm: ncModel.windFarm,
                platform: ncModel.platform,
                oem: ncModel.oem,
                turbineNo: ncModel.turbineNo,
              );
            }

            return Scaffold(
              backgroundColor: theme.colorScheme.background,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Text('NC - ${nc.id}'),
                leading: IconButton(
                  onPressed: () async {
                    await showAlert(context);
                  },
                  icon: const Icon(Icons.close_outlined),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: updateNC,
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              hintText: 'Enter Title',
                              hintStyle: theme.textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const LabelWidget("Problem Description"),
                          const SizedBox(height: 6),
                          TextField(
                            controller: problemDescriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              hintText: 'Enter Problem Description',
                              hintStyle: theme.textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 8),
                          NCWindFarm(
                            windFarm,
                            onSelected: (windFarm) {
                              setState(() {
                                this.windFarm = windFarm;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: const LabelWidget('Status'),
                            trailing: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: status,
                                style: theme.textTheme.bodyMedium!,
                                dropdownColor: theme.colorScheme.surface,
                                items: statuses
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    status = value!;
                                  });
                                },
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
                                style: theme.textTheme.bodyMedium!,
                                dropdownColor: theme.colorScheme.surface,
                                items: severities
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    severity = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          NCAssign(
                            ref: ref,
                            onAssign: (assignedTo) {
                              setState(() {
                                this.assignedTo.addAll(assignedTo.toList());
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          NCAttachments(ncId: ncModel.id),
                          const SizedBox(height: 8),
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
