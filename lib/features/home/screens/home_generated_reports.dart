import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/reports_dashboard/controller/reports_controller.dart';
import 'package:windsy_solve/features/reports_dashboard/widgets/show_report.dart';
import 'package:windsy_solve/models/reports/reports_model.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

class HomeGeneratedReports extends StatelessWidget {
  const HomeGeneratedReports({super.key});

  //tab view without scaffold
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: TabBar(
              tabs: [
                Tab(
                  text: 'NC Reports',
                ),
                Tab(
                  text: 'Inspection Reports',
                ),
              ],
            ),
          ),
          Flexible(
            child: TabBarView(
              children: [
                GeneratedNCReports(),
                GeneratedInspectionReports(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratedNCReports extends ConsumerWidget {
  const GeneratedNCReports({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getNCReportsProvider).when(
          data: (ncReport) {
            if (ncReport.isEmpty) {
              return const Center(
                child: Text(
                  'No reports generated yet!',
                ),
              );
            }
            return ListView.builder(
              itemCount: ncReport.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ReportListTile(
                      report: ncReport[index],
                    ),
                    if (index != ncReport.length - 1)
                      const Divider(
                        color: Colors.grey,
                        height: 0.0,
                      ),
                  ],
                );
              },
            );
          },
          error: (e, s) => ErrorText(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}

class GeneratedInspectionReports extends ConsumerWidget {
  const GeneratedInspectionReports({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getInspectionReportsProvider).when(
          data: (inspectionReport) {
            if (inspectionReport.isEmpty) {
              return const Center(
                child: Text(
                  'No reports generated yet!',
                ),
              );
            }
            return ListView.builder(
              itemCount: inspectionReport.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ReportListTile(
                      report: inspectionReport[index],
                    ),
                    if (index != inspectionReport.length - 1)
                      const Divider(
                        color: Colors.grey,
                        height: 0.0,
                      ),
                  ],
                );
              },
            );
          },
          error: (e, s) => ErrorText(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}

class ReportListTile extends ConsumerWidget {
  const ReportListTile({
    super.key,
    required this.report,
  });

  final ReportModel report;

  void _downloadReport(
    WidgetRef ref,
    BuildContext context,
    String url,
    String fileName,
  ) {
    ref.read(reportsControllerProvider.notifier).downloadReport(
          context,
          url,
          fileName,
        );
  }

  void _deleteReport(
    WidgetRef ref,
    BuildContext context,
    String url,
    String fileId,
    String fileType,
  ) {
    ref.read(reportsControllerProvider.notifier).deleteReport(
          context,
          url,
          fileId,
          fileType,
        );
  }

  void _openReport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowReport(
          id: 'id',
          report: report,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () => _openReport(context),
      leading: const Icon(
        Icons.file_copy_rounded,
        size: 20.0,
      ),
      title: Text(
        report.fileName,
        style: theme.textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NC - ${report.associatedTo}',
            style: theme.textTheme.bodySmall!.copyWith(
              fontSize: 12.0,
            ),
          ),
          Text(
            'Generated on ${report.createdAt.toDateTimeString()}',
            style: theme.textTheme.bodySmall!.copyWith(
              fontSize: 10.0,
            ),
          ),
          /* Text(
            'Generated by ${report.createdBy}',
            style: theme.textTheme.labelSmall,
          ), */
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.download_rounded,
              size: 20.0,
            ),
            onPressed: () => _downloadReport(
              ref,
              context,
              report.fileUrl,
              report.fileName,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_forever_rounded,
              size: 20.0,
              color: Colors.red,
            ),
            onPressed: () => _deleteReport(
              ref,
              context,
              report.fileUrl,
              report.id,
              'nc',
            ),
          ),
        ],
      ),
    );
  }
}
