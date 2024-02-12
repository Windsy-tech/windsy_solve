import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';

class InspectionSection extends ConsumerStatefulWidget {
  final String inspectionId;
  const InspectionSection({super.key, required this.inspectionId});

  @override
  ConsumerState<InspectionSection> createState() =>
      _CreateConsumerInspectionSectionState();
}

class _CreateConsumerInspectionSectionState
    extends ConsumerState<InspectionSection> {
  final sectionNameController = TextEditingController();

  Future showSectionDialog() {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const LabelWidget("Add Section"),
          content: TextField(
            controller: sectionNameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: 'Enter a Section Name',
              hintStyle: theme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: theme.textTheme.labelMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                addSection(context, sectionNameController.text);
                sectionNameController.clear();
              },
              child: Text(
                "Add",
                style: theme.textTheme.labelMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  Future showSaveAlertDialog() {
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.warning, color: Colors.yellow),
          title: Text(
            "Warning!",
            style: theme.textTheme.headlineLarge,
          ),
          content: Text(
            "Inorder to create a section, you need to save the inspection first",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                //saveInspection();
              },
              child: Text(
                "OK",
                style: theme.textTheme.labelMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  void addSection(BuildContext context, String sectionName) async {
    ref.read(inspectionControllerProvider.notifier).updateSection(
          context,
          widget.inspectionId,
          sectionName,
        );
  }

  void navigateToSectionPage(BuildContext context, String sectionName) {
    Routemaster.of(context).push(
      "/inspection/section/$sectionName",
      queryParameters: {
        "id": widget.inspectionId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final inspection = ref.watch(inspectionProvider);
    final isExists =
        ref.watch(checkInspectionIdExistsProvider(widget.inspectionId)).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const LabelWidget("Sections"),
            IconButton(
              onPressed: () async {
                if (isExists != null && !isExists) {
                  await showSaveAlertDialog();
                  return;
                } else {
                  await showSectionDialog();

                  if (sectionNameController.text.isNotEmpty) {
                    inspection.sections!.add(sectionNameController.text);
                  }
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        isExists != null && isExists
            ? ref
                .watch(getInspectionSectionsProvider(widget.inspectionId))
                .when(
                  data: (sections) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () => navigateToSectionPage(
                            context,
                            sections[index],
                          ),
                          visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: -4,
                          ),
                          leading: const Icon(Icons.list),
                          title: Text(
                            sections[index],
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 14,
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, s) => const Center(
                    child: Text("Error"),
                  ),
                )
            : const SizedBox()
      ],
    );
  }

  @override
  void dispose() {
    sectionNameController.dispose();
    super.dispose();
  }
}
