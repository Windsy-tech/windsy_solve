import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/features/nc/widgets/nc_assign.dart';
import 'package:windsy_solve/features/nc/widgets/nc_wind_farm.dart';
import 'package:windsy_solve/models/common/windfarm_model.dart';
import 'package:windsy_solve/models/nc/nc_model.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class ReportNCScreen extends ConsumerStatefulWidget {
  final String title;

  const ReportNCScreen({required this.title, super.key});
  static const routeName = '/non-conformity';

  @override
  ConsumerState<ReportNCScreen> createState() =>
      _CreateConsumerReportNCScreenState();
}

class _CreateConsumerReportNCScreenState extends ConsumerState<ReportNCScreen> {
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
    ref.read(ncControllerProvider.notifier).createNC(
          context,
          user!.companyId,
          NCModel(
            id: widget.title,
            title: titleController.text,
            problemDescription: problemDescriptionController.text,
            status: status,
            severity: severities.indexOf(severity),
            category: '',
            windFarm: windFarm.windFarm!,
            turbineNo: windFarm.turbineNo!,
            platform: windFarm.platform!,
            oem: windFarm.oem!,
            assignedTo: assignedTo,
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
    problemDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Non-Conformity: ${widget.title}',
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                    null,
                    onSelected: (windFarm) {
                      setState(() {
                        this.windFarm = windFarm as WindFarmModel;
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
                    leading: const LabelWidget('Severity'),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: severity,
                        style: theme.textTheme.bodyMedium!,
                        dropdownColor: theme.colorScheme.surface,
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
                  NCAssign(
                    ref: ref,
                    onAssign: (assignedTo) {
                      setState(() {
                        this.assignedTo = assignedTo.toList();
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  /* Column(
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
                  ), */
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 20.0,
                      ),
                    ),
                    onPressed: () => createNC(),
                    child: Text(
                      'Create NC',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
