import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/constants/constants.dart';

showNCModelBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return const NCBottomSheet();
    },
  );
}

class NCBottomSheet extends ConsumerStatefulWidget {
  const NCBottomSheet({super.key});

  @override
  ConsumerState<NCBottomSheet> createState() => _NCBottomSheetState();
}

class _NCBottomSheetState extends ConsumerState<NCBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  showTitleDialog({
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            "Enter Non-Conformity Name",
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToPerformNC(
                  context,
                  controller.text,
                );
              },
              child: Text(
                "Next",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  void navigateToPerformNC(
    BuildContext context,
    String title,
  ) {
    Routemaster.of(context).push(
      Constants.rReportNC,
      queryParameters: {
        'title': title,
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ListTile(
                onTap: () => showTitleDialog(
                  context: context,
                ),
                contentPadding: const EdgeInsets.all(6.0),
                leading: const Icon(
                  Icons.new_label,
                  size: 20,
                ),
                title: Text(
                  "Create New",
                  style: theme.textTheme.bodyMedium,
                ),
                dense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
