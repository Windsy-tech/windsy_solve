import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/models/reports/reports_model.dart';
import 'package:windsy_solve/services/share/share_service.dart';
import 'package:windsy_solve/theme/color_palette.dart';
import 'package:windsy_solve/utils/progress_count.dart';

class ShowReport extends ConsumerStatefulWidget {
  final String id;
  final ReportModel report;

  const ShowReport({
    super.key,
    required this.id,
    required this.report,
  });

  @override
  ConsumerState<ShowReport> createState() => _CreateConsumerShowReportState();
}

class _CreateConsumerShowReportState extends ConsumerState<ShowReport> {
  void shareFile(String url) async {
    final shareService = ShareService();
    await shareService.shareFile(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.report.fileName,
          style: theme.textTheme.labelLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              shareFile(widget.report.fileUrl);
            },
            icon: const Icon(Icons.share),
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
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: const PDF().fromUrl(
                    widget.report.fileUrl,
                    placeholder: (bytes) => Center(
                      child: Text(
                        downloadProgressIndicatorForFile(bytes),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
