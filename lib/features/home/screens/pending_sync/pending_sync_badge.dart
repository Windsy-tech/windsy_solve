import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/home/screens/pending_sync/controller/sync_task_controller.dart';

class PendingSyncBadge extends ConsumerWidget {
  const PendingSyncBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTotalSyncTasksCountProvider).when(
          data: (count) {
            return IconButton(
              tooltip: count != 0 ? '$count Sync Pending' : 'No Sync Pending',
              disabledColor: const Color.fromRGBO(158, 158, 158, 1),
              onPressed: () => count != 0
                  ? Routemaster.of(context).push('/pending-sync')
                  : null,
              icon: Badge(
                label: Text(count.toString()),
                isLabelVisible: count != 0,
                child: Icon(
                  Icons.sync_rounded,
                  size: 24,
                  color: count != 0 ? Colors.red : Colors.grey,
                ),
              ),
            );
          },
          error: (e, s) => ErrorText(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}
