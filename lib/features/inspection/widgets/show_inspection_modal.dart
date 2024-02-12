import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';

showInspectionModelBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    //isScrollControlled: true,
    // backgroundColor: Colors.transparent,
    builder: (context) {
      return const InspectionBottomSheet();
    },
  );
}

class InspectionBottomSheet extends ConsumerStatefulWidget {
  const InspectionBottomSheet({super.key});

  @override
  ConsumerState<InspectionBottomSheet> createState() =>
      _InspectionBottomSheetState();
}

class _InspectionBottomSheetState extends ConsumerState<InspectionBottomSheet>
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
    required String type,
    required String templateName,
  }) {
    final theme = Theme.of(context);
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Enter Inspection Name",
            style: theme.textTheme.headlineSmall,
          ),
          content: TextField(
            controller: controller,
            maxLength: 50,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: 'Enter a Inspection Name',
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
                style: theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToPerformInspection(
                  context,
                  controller.text,
                  type,
                  templateName,
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

  void navigateToPerformInspection(
    BuildContext context,
    String title,
    String type,
    String templateName,
  ) {
    Routemaster.of(context).push(
      Constants.rPerformInspection,
      queryParameters: {
        'title': title,
        'type': type,
        'templateName': templateName,
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
          TabBar(
            controller: _tabController,
            labelStyle: theme.textTheme.bodyMedium,
            labelColor: theme.colorScheme.onPrimary,
            tabs: const [
              Tab(
                text: "New",
                icon: Icon(
                  Icons.new_label_outlined,
                ),
              ),
              Tab(
                text: "Templates",
                icon: Icon(
                  Icons.extension_outlined,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Content for the "New" tab
                Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ListTile(
                          onTap: () => showTitleDialog(
                            context: context,
                            type: "new",
                            templateName: "",
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
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ref.watch(getInspectionTemplatesProvider).when(
                          data: (templates) {
                            if (templates.isEmpty) {
                              return const Center(
                                child: Text("No Templates Found"),
                              );
                            }
                            return ListView.builder(
                                itemBuilder: (context, index) {
                              final template = templates[index];
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: ListTile(
                                    onTap: () => showTitleDialog(
                                      context: context,
                                      type: "template",
                                      templateName: template.name,
                                    ),
                                    contentPadding: const EdgeInsets.all(6.0),
                                    leading: const Icon(
                                      Icons.new_label,
                                      size: 16,
                                    ),
                                    title: Text(
                                      template.name,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    dense: true,
                                  ),
                                ),
                              );
                            });
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (e, s) => const Center(
                            child: Text("Error Fetching Templates"),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
