import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/inspection/controller/inspection_controller.dart';
import 'package:windsy_solve/features/reports_dashboard/widgets/report_list_tile.dart';
import 'package:windsy_solve/models/inspection_model.dart';

class InspectionReports extends ConsumerWidget {
  const InspectionReports({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspectionData = ref.watch(getUserInspectionProvider);
    final user = ref.read(userProvider)!;

    print("ui rebuilt");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inspection Reports"),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(getUserInspectionProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: inspectionData.when(
        data: (inspections) {
          if (inspections.isEmpty) {
            return const Center(
              child: Text("No Inspection Reports Found"),
            );
          }
          return ListView.builder(
            itemCount: inspections.length,
            itemBuilder: (context, index) {
              InspectionModel inspection = inspections[index];
              return ReportListTile(
                id: inspection.id,
                status: inspection.status,
                title: inspection.title,
                windFarm: inspection.windFarm,
                createdAt: inspection.createdAt,
                onTapClose: () {
                  ref.read(inspectionControllerProvider.notifier).closeNC(
                        context,
                        user.companyId,
                        inspection.id,
                      );
                },
                onTapDelete: () {
                  ref.read(inspectionControllerProvider.notifier).deleteNC(
                        context,
                        user.companyId,
                        inspection.id,
                      );
                },
                onTap: () {
                  Routemaster.of(context).push(
                    '/inspection/${inspection.id}',
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
