import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/reports_dashboard/widgets/report_nc_list_tile.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';

class NCReports extends ConsumerWidget {
  const NCReports({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ncData = ref.watch(getUserNCProvider);
    print("ui rebuilt");

    return Scaffold(
      appBar: AppBar(
        title: const Text("NC Reports"),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(getUserNCProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ncData.when(
        data: (ncs) {
          if (ncs.isEmpty) {
            return const Center(
              child: Text("No Non-Conformitiy Reports Found"),
            );
          }
          return ListView.builder(
            itemCount: ncs.length,
            itemBuilder: (context, index) {
              return ReportNCListTile(
                nc: ncs[index],
                onTap: () {
                  Routemaster.of(context).push(
                    '/non-conformity/${ncs[index].id}',
                  );
                },
              );
            },
          );
        },
        loading: () => const Loader(),
        error: (e, s) => ErrorText(error: e.toString()),
      ),
    );
  }
}
