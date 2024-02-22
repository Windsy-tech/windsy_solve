import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/inspection/controller/check_list_controller.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';

class CheckListActionsPage extends StatefulWidget {
  final String checkListId;
  CheckListModel checkListModel;
  CheckListActionsPage({
    required this.checkListId,
    required this.checkListModel,
    super.key,
  });

  @override
  State<CheckListActionsPage> createState() => _CheckListActionsPageState();
}

class _CheckListActionsPageState extends State<CheckListActionsPage> {
  late CheckListModel checkList;

  @override
  void initState() {
    super.initState();
    checkList = widget.checkListModel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: Consumer(
          builder: (context, ref, child) {
            return IconButton(
              onPressed: () {
                ref.read(checkListControllerProvider.notifier).updateCheckList(
                      context,
                      widget.checkListId,
                      checkList,
                    );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            );
          },
        ),
        title: const Text("Actions"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _addActionField(context);
            },
            icon: const Icon(Icons.add),
            tooltip: "Add an action",
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: checkList.actions.length,
        //provider.checkList.Actions.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await _showDeleteDialog(context, index);
            },
            background: const ColoredBox(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: ListTile(
              dense: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              onTap: () => _showActionDialog(context, index),
              leading: const Icon(
                Icons.reviews_outlined,
              ),
              title: Text(
                checkList.actions[index],
                style: theme.textTheme.bodyLarge,
              ),
            ),
          );
        },
      ),
    );
  }

  //Delete a Action
  Future<bool?> _showDeleteDialog(BuildContext context, int index) async {
    final theme = Theme.of(context);
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text("Delete action"),
          content: const Text(
            "Are you sure you want to delete? This action cannot be undone!",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                //TODO: Remove an action
                setState(() {
                  checkList.actions.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  //Add a Action
  _addActionField(BuildContext context) {
    final theme = Theme.of(context);
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.all(8.0),
          actionsPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 2.0,
          ),
          titlePadding: const EdgeInsets.only(
            top: 16.0,
            left: 8.0,
            bottom: 4.0,
          ),
          buttonPadding: const EdgeInsets.all(0.0),
          title: Text(
            "Add Action",
            style: theme.textTheme.titleSmall,
          ),
          content: TextField(
            controller: controller,
            maxLength: 50,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  checkList.actions.add(controller.text);
                });
                controller.clear();
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  //show dialog where the text is entered
  _showActionDialog(BuildContext context, index) {
    final theme = Theme.of(context);
    TextEditingController controller = TextEditingController();
    controller.text = checkList.actions[index];
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.all(8.0),
          actionsPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 2.0,
          ),
          titlePadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 8.0,
          ),
          buttonPadding: const EdgeInsets.all(0.0),
          title: const Text(
            "Edit Action",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLength: 50,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  checkList.actions[index] = controller.text;
                });
                controller.clear();
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }
}
