import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/inspection/controller/check_list_controller.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';

// ignore: must_be_immutable
class CheckListNotesPage extends ConsumerStatefulWidget {
  final String checkListId;
  CheckListModel checkList;
  CheckListNotesPage(
      {required this.checkListId, required this.checkList, super.key});

  @override
  ConsumerState<CheckListNotesPage> createState() => _CheckListNotesPageState();
}

class _CheckListNotesPageState extends ConsumerState<CheckListNotesPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.checkList.notes;
  }

  void updateNotes(BuildContext context, WidgetRef ref) {
    widget.checkList = widget.checkList.copyWith(notes: _controller.text);
    ref.read(checkListControllerProvider.notifier).updateCheckList(
          context,
          widget.checkListId,
          widget.checkList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            updateNotes(context, ref);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: const Text("Notes"),
      ),
      body: Container(
        height: size.height,
        color: theme.colorScheme.surface,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (text) {
                        //provider.notes = text;
                        //print(provider.checkList.notes);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter notes here...",
                      ),
                      maxLines: null,
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
