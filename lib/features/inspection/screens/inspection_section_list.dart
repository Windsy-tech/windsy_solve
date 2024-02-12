import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';
import 'package:windsy_solve/models/section_model.dart';

class InspectionSectionList extends ConsumerStatefulWidget {
  final String inspectionId;
  final String sectionName;
  const InspectionSectionList({
    super.key,
    required this.inspectionId,
    required this.sectionName,
  });

  @override
  ConsumerState<InspectionSectionList> createState() =>
      _CreateConsumerInspectionSectionListState();
}

class _CreateConsumerInspectionSectionListState
    extends ConsumerState<InspectionSectionList> {
  final checkListController = TextEditingController();

  late SectionModel sectionModel;

  @override
  void initState() {
    sectionModel = SectionModel(
      inspectionId: widget.inspectionId,
      sectionName: widget.sectionName,
    );
    super.initState();
  }

  @override
  void dispose() {
    checkListController.dispose();
    super.dispose();
  }

  Future showAddCheckListDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new check"),
          content: TextField(
            controller: checkListController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: "Check Name",
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
                addCheckList(context, checkListController.text);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void addCheckList(BuildContext context, String checkListName) {
    ref.read(inspectionControllerProvider.notifier).addChecklist(
          context,
          widget.inspectionId,
          widget.sectionName,
          checkListName,
        );
    checkListController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final checkLists =
        ref.watch(getChecklistsFromSectionProvider(sectionModel));
    print('ui rebuilt');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sectionName),
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => showAddCheckListDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: checkLists.when(
        data: (checklists) {
          return ListView.builder(
            itemCount: checklists.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(checklists[index]),
                onTap: () {},
              );
            },
          );
        },
        loading: () => const Loader(),
        error: (error, stackTrace) => ErrorText(
          error: error.toString(),
        ),
      ),
    );
  }
}
