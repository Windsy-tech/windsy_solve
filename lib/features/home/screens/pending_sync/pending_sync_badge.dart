import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/providers/firebase_providers.dart';

class PendingSyncBadge extends ConsumerWidget {
  const PendingSyncBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncTasks = ref.watch(localDataProvider).getNCSyncTasksCount();
    return FutureBuilder(
      future: syncTasks,
      builder: (context, s) {
        return IconButton(
          onPressed: () => Routemaster.of(context).push('/pending-sync'),
          icon: Badge(
            label: Text(s.data.toString()),
            isLabelVisible: s.data != 0,
            child: const Icon(
              Icons.sync_rounded,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
