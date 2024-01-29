import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
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

  void navigateToPerformInspection(
    BuildContext context,
    String type,
    String templateName,
  ) {
    Routemaster.of(context).push('/perform-inspection', queryParameters: {
      'type': type,
      'templateName': templateName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "New", icon: Icon(Icons.new_label_outlined)),
              Tab(text: "Templates", icon: Icon(Icons.extension_outlined)),
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
                          onTap: () => navigateToPerformInspection(
                            context,
                            "new",
                            "",
                          ),
                          contentPadding: const EdgeInsets.all(2),
                          leading: const Icon(
                            Icons.new_label,
                            size: 16,
                          ),
                          title: const Text("Create New"),
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
                                    onTap: () => navigateToPerformInspection(
                                      context,
                                      "template",
                                      template.name,
                                    ),
                                    contentPadding: const EdgeInsets.all(2),
                                    leading: const Icon(
                                      Icons.new_label,
                                      size: 16,
                                    ),
                                    title: Text(template.name),
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
