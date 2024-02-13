import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/inspection/controller/check_list_controller.dart';
import 'package:windsy_solve/features/inspection/screens/check_list/check_list_component.dart';
import 'package:windsy_solve/models/checklist_model.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class CheckListScreen extends ConsumerStatefulWidget {
  final String section;
  final String checkId;
  const CheckListScreen({
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
      section: widget.section,
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
        title: Text('Check - $widget.checkId'),
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
            child: const Column(
              children: [
                ListTile(
                  title: Text(
                    'Component',
                  ),
                )
              ],
            ),
          );
        },
        error: (e, s) => ErrorText(error: e.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
