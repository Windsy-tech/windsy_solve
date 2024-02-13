import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/inspection/controller/check_list_controller.dart';
import 'package:windsy_solve/models/checklist_model.dart';

class CheckListCheckSearchDelegate extends SearchDelegate {
  final WidgetRef ref;
  final String checkListId;
  CheckListModel checkList;
  List<String> checks = [];

  CheckListCheckSearchDelegate({
    required this.ref,
    required this.checkListId,
    required this.checkList,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
        ref.read(checkListControllerProvider.notifier).updateCheckList(
              context,
              checkListId,
              checkList,
            );
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (checks.isEmpty) {
      return _buildCustomFieldPrompt(context);
    } else {
      return _buildSelectedCheck(context);
    }
  }

  Widget _buildCustomFieldPrompt(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'No matching checks found.',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showAddCustomFieldDialog(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              backgroundColor: theme.colorScheme.secondaryContainer,
            ),
            child: Text(
              'Add Custom Field',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomFieldDialog(BuildContext context) {
    TextEditingController customFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Custom Check'),
          content: TextField(
            controller: customFieldController,
            decoration: const InputDecoration(
              labelText: 'Check Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String customCheck = customFieldController.text;
                if (customCheck.isNotEmpty) {
                  // Save the custom check (you can customize this logic)
                  checks.add(customCheck);
                  checkList.copyWith(
                    checks: customCheck,
                  );
                  ref
                      .read(checkListControllerProvider.notifier)
                      .addNewCheck(
                        context,
                        customCheck,
                      );
                  showResults(context);
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedCheck(BuildContext context) {
    return ListTile(
      title: Text(checkList.checks),
      trailing: const Icon(Icons.check),
      onTap: () {
        Routemaster.of(context).pop();
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return Theme.of(context).copyWith(
      // hide textfield underline
      scaffoldBackgroundColor: theme.colorScheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.textTheme.labelLarge,
        border: InputBorder.none,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(getChecksProvider(query)).when(
          data: (fetchedChecks) {
            checks = fetchedChecks;
            return _CheckListCheckSearchResults(
              checks: checks,
              check: checkList.checks,
              onTap: (data) {
                checkList = checkList.copyWith(
                  checks: data,
                );
                showResults(context);
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}

class _CheckListCheckSearchResults extends StatefulWidget {
  final List<String> checks;
  final String check;
  final Function(String) onTap;

  _CheckListCheckSearchResults({
    required this.checks,
    required this.check,
    required this.onTap,
  });

  @override
  _CheckListCheckSearchResultsState createState() =>
      _CheckListCheckSearchResultsState();
}

class _CheckListCheckSearchResultsState
    extends State<_CheckListCheckSearchResults> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: ListView.builder(
        itemCount: widget.checks.length,
        itemBuilder: (BuildContext context, int index) {
          final data = widget.checks[index];
          return ListTile(
            onTap: () {
              widget.onTap(data);
            },
            title: Text(data),
            trailing: data == widget.check
                ? const Icon(Icons.check)
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
