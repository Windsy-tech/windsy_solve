import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';
import 'package:windsy_solve/features/inspection/screens/check_list/check_list_screen.dart';
import 'package:windsy_solve/models/inspection/section_model.dart';
import 'package:windsy_solve/theme/color_palette.dart';

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
    final theme = Theme.of(context);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new check"),
          backgroundColor: theme.colorScheme.surface,
          content: TextField(
            controller: checkListController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: "Check Name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
              ),
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

  void navigateToCheckListPage(String checkId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CheckListScreen(
            inspectionId: widget.inspectionId,
            checkId: checkId,
            section: widget.sectionName,
          );
        },
      ),
    );
    //Routemaster.of(context).push('check/$checkId');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final checkLists =
        ref.watch(getChecklistsFromSectionProvider(sectionModel));
    print('ui rebuilt');
    print(Routemaster.of(context).currentRoute);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.sectionName),
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showAddCheckListDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: checkLists.when(
        data: (checklists) {
          return Container(
            height: size.height,
            decoration: BoxDecoration(
              gradient: theme.brightness == Brightness.dark
                  ? ColorPalette.darkSurface
                  : ColorPalette.lightSurface,
            ),
            child: ListView.builder(
              itemCount: checklists.length,
              itemExtentBuilder: ((index, dimensions) => 60.0),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    checklists[index],
                    style: theme.textTheme.bodyLarge,
                  ),
                  onTap: () => navigateToCheckListPage(checklists[index]),
                );
              },
            ),
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
