import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/providers/sync_task/sync_task_controller.dart';

class PendingSyncBadge extends ConsumerWidget {
  const PendingSyncBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncTasks = ref.watch(localDatabaseProvider).getTotalSyncTasksCount();
    return FutureBuilder(
      future: syncTasks,
      builder: (context, s) {
        return IconButton(
          tooltip: s.data != 0 ? '${s.data} Sync Pending' : 'No Sync Pending',
          disabledColor: const Color.fromRGBO(158, 158, 158, 1),
          onPressed: () => s.data != 0
              ? Routemaster.of(context).push('/pending-sync')
              : null,
          icon: Badge(
            label: Text(s.data.toString()),
            isLabelVisible: s.data != 0,
            child: Icon(
              Icons.sync_rounded,
              size: 24,
              color: s.data != 0 ? Colors.red : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
