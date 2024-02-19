import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/home/screens/pending_sync/controller/sync_task_controller.dart';
import 'package:windsy_solve/theme/color_palette.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

class PendingSync extends ConsumerWidget {
  const PendingSync({super.key});

  void _syncAll(WidgetRef ref) {
    ref.read(syncTaskControllerProvider).syncNCTasks(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final syncNCTasks = ref.watch(syncTaskControllerProvider).getNCSyncTasks();
    final syncInspectionTasks =
        ref.watch(syncTaskControllerProvider).getInspectionSyncTasks();
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Pending Sync'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _syncAll(ref),
            child: const Text(
              'Sync All',
            ),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: theme.brightness == Brightness.dark
              ? ColorPalette.darkSurface
              : ColorPalette.lightSurface,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: syncNCTasks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Non-Conformities',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Pending : ${snapshot.data!.length}',
                              style: theme.textTheme.titleSmall,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    dense: true,
                                    visualDensity: const VisualDensity(
                                      vertical: -4,
                                      horizontal: 0,
                                    ),
                                    title: Text(
                                      snapshot.data![index].ncModel.id,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    subtitle: Text(
                                      'Updated at ${snapshot.data![index].ncModel.updatedAt.toDateTimeString()}',
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: syncInspectionTasks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inspections',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'Pending : ${snapshot.data!.length}',
                              style: theme.textTheme.titleSmall,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Text(
                                      snapshot.data![index].inspectionModel.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
