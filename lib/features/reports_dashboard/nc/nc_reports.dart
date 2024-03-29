import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/auth/controller/auth_controller.dart';
import 'package:windsy_solve/features/reports_dashboard/widgets/report_list_tile.dart';
import 'package:windsy_solve/features/nc/controller/nc_controller.dart';
import 'package:windsy_solve/models/nc/nc_model.dart';

class NCReports extends ConsumerWidget {
  const NCReports({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ncData = ref.watch(getUserNCProvider);
    final user = ref.read(userProvider)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "NC Reports",
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).history.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
            return Center(
              child: Text(
                "No Non-Conformitiy Reports Found",
                style: theme.textTheme.headlineLarge,
              ),
            );
          }
          return ListView.builder(
            itemCount: ncs.length,
            itemBuilder: (context, index) {
              NCModel nc = ncs[index];
              return ReportListTile(
                id: nc.id,
                status: nc.status,
                title: nc.title,
                windFarm: nc.windFarm,
                createdAt: nc.createdAt,
                onTapGenerateReport: () {
                  Routemaster.of(context).push(
                    '/generate-nc-report',
                  );
                },
                onTapClose: () {
                  ref.read(ncControllerProvider.notifier).closeNC(
                        context,
                        user.companyId,
                        nc.id,
                      );
                },
                onTapDelete: () {
                  ref.read(ncControllerProvider.notifier).deleteNC(
                        context,
                        user.companyId,
                        nc.id,
                      );
                },
                onTap: () {
                  Routemaster.of(context).push(
                    '/non-conformity/${nc.id}',
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
