import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_end_date.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_section.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_start_date.dart';
import 'package:windsy_solve/features/inspection/widgets/inspection_wind_farm.dart';
import 'package:windsy_solve/models/common/windfarm_model.dart';
import 'package:windsy_solve/models/inspection/inspection_model.dart';
import 'package:windsy_solve/theme/color_palette.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

class PerformInspectionScreen extends ConsumerStatefulWidget {
  final String title;
  final String type;
  final String templateName;
  const PerformInspectionScreen({
    required this.title,
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
  List<String> sections = [];
  WindFarmModel windFarm = WindFarmModel();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  bool validator(BuildContext test) {
    if (titleController.text.isEmpty || windFarm.windFarm == null) {
      return false;
    } else {
      return true;
    }
  }

  void createInspection(BuildContext context) {
    if (!validator(context)) {
      showSnackBar(
        context,
        'Title & Wind Farm cannot be empty',
        SnackBarType.error,
      );
      return;
    }
    final user = ref.read(userProvider)!;
    ref.read(inspectionControllerProvider.notifier).createNC(
          context,
          user.companyId,
          InspectionModel(
            id: widget.title,
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
            members: [],
            assignedTo: assignedTo,
            sections: sections,
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
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Routemaster.of(context).history.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              createInspection(context);
            },
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
                  TextFormField(
                    controller: titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  InspectionStartDate(
                    startDate: startDate,
                    endDate: endDate,
                    onChanged: (date) {
                      setState(() {
                        startDate = date!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  InspectionEndDate(
                    startDate: startDate,
                    endDate: endDate,
                    onChanged: (date) {
                      setState(() {
                        endDate = date!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  InspectionWindFarm(
                    null,
                    onSelected: (windFarm) {
                      setState(() {
                        this.windFarm = windFarm as WindFarmModel;
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
                  InspectionSection(
                    inspectionId: widget.title,
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
