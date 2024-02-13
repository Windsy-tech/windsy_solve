import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/core/common/widgets/created_modified_by.dart';
import 'package:windsy_solve/features/inspection/controller/check_list_controller.dart';
import 'package:windsy_solve/features/inspection/delegates/check_list/check_search_delegate.dart';
import 'package:windsy_solve/features/inspection/delegates/check_list/components_search_delegate.dart';
import 'package:windsy_solve/features/inspection/screens/check_list/notes_page.dart';
import 'package:windsy_solve/features/inspection/screens/check_list/risk_page.dart';
import 'package:windsy_solve/features/inspection/screens/check_list/type_page.dart';
import 'package:windsy_solve/features/inspection/widgets/check_list/check_list_listtile.dart';
import 'package:windsy_solve/models/checklist_model.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class CheckListScreen extends ConsumerStatefulWidget {
  final String inspectionId;
  final String section;
  final String checkId;
  const CheckListScreen({
    required this.inspectionId,
    required this.section,
    required this.checkId,
    super.key,
  });
  @override
  ConsumerState<CheckListScreen> createState() =>
      _CreateConsumerCheckListScreenState();
}

class _CreateConsumerCheckListScreenState
    extends ConsumerState<CheckListScreen> {
  late CheckListModel checkList;
  @override
  void initState() {
    super.initState();
    checkList = CheckListModel(
      id: widget.checkId,
      inspectionId: widget.inspectionId,
      section: widget.section,
    );
  }

  void showComponentSearchDelegate(CheckListModel checkList) {
    showSearch(
      context: context,
      delegate: CheckListComponentSearchDelegate(
        ref: ref,
        checkListId: widget.checkId,
        checkList: checkList,
      ),
    );
  }

  void showCheckSearchDelegate(CheckListModel checkList) {
    showSearch(
      context: context,
      delegate: CheckListCheckSearchDelegate(
        ref: ref,
        checkListId: widget.checkId,
        checkList: checkList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final checkListData = ref.watch(getCheckListByIdProvider(checkList));
    print(Routemaster.of(context).currentRoute);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Check - ${widget.checkId}',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: checkListData.when(
        data: (checkList) {
          return Container(
            height: size.height,
            decoration: BoxDecoration(
              gradient: theme.brightness == Brightness.dark
                  ? ColorPalette.darkSurface
                  : ColorPalette.lightSurface,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Component
                  CheckListListTile(
                    title: 'Component',
                    value: checkList.system,
                    onTap: () => showComponentSearchDelegate(checkList),
                  ),

                  //Check
                  CheckListListTile(
                    title: 'Check',
                    value: checkList.checks,
                    onTap: () => showCheckSearchDelegate(checkList),
                  ),

                  //Type
                  CheckListListTile(
                    title: 'Type',
                    value: checkList.type,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CheckListTypePage(
                              checkListId: widget.checkId,
                              checkList: checkList,
                            );
                          },
                        ),
                      );
                    },
                  ),

                  //Risk
                  CheckListListTile(
                    title: 'Risk',
                    value: checkList.risk.toString(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CheckListRiskPage(
                              checkListId: widget.checkId,
                              checkList: checkList,
                            );
                          },
                        ),
                      );
                    },
                  ),

                  //Status
                  CheckListListTile(
                    title: 'Status',
                    value: checkList.closed ? 'Closed' : 'Open',
                    onTap: () {},
                  ),

                  //Notes
                  CheckListListTile(
                    title: 'Notes',
                    value: checkList.notes,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CheckListNotesPage(
                              checkListId: widget.checkId,
                              checkList: checkList,
                            );
                          },
                        ),
                      );
                    },
                  ),

                  //Comments
                  CheckListListTile(
                    title: 'Comments',
                    onTap: () {},
                  ),

                  //Created and Modified
                  CreatedModifiedBy(
                    createdBy: checkList.createdBy,
                    createdAt: checkList.createdAt,
                    modifiedBy: checkList.modifiedBy,
                    modifiedAt: checkList.modifiedAt,
                  ),
                ],
              ),
            ),
          );
        },
        error: (e, s) => ErrorText(error: e.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
