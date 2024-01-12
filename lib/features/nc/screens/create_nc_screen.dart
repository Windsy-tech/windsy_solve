import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportNC extends ConsumerStatefulWidget {
  const ReportNC({Key? key}) : super(key: key);
  static const routeName = '/non-conformity';

  @override
  ConsumerState<ReportNC> createState() => _CreateConsumerReportNCState();
}

class _CreateConsumerReportNCState extends ConsumerState<ReportNC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report NC'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title"),
              TextField(),
              Text("Title"),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
