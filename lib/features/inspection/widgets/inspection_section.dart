import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool isExists = false;
  @override
  void initState() {
    super.initState();
    isExists = Future.delayed(const Duration(seconds: 1), () {
      ref
          .watch(inspectionControllerProvider.notifier)
          .checkIfInspectionIdExists(
            widget.inspectionId,
          );
    }) as bool;
    print(isExists);
  }

  Future showSectionDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Section"),
          content: TextField(
            controller: sectionNameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: "Section Name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                addSection(sectionNameController.text);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void addSection(String sectionName) async {
    ref.read(inspectionControllerProvider.notifier).addSection(
          widget.inspectionId,
          sectionName,
        );
  }

  @override
  Widget build(BuildContext context) {
    final inspection = ref.watch(inspectionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Sections"),
            IconButton(
              onPressed: () async {
                await showSectionDialog();

                if (sectionNameController.text.isNotEmpty) {
                  //addSection(sectionNameController.text);
                  inspection.sections!.add(sectionNameController.text);
                  print(inspection.sections);
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        isExists
            ? ref
                .watch(getInspectionSectionsProvider(widget.inspectionId))
                .when(
                  data: (sections) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: sections.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(sections[index]),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete),
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
}
