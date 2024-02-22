import 'package:flutter/material.dart';
import 'package:windsy_solve/features/analytics/widgets/nc_by_month_chart.dart';
import 'package:windsy_solve/features/analytics/widgets/nc_by_status_chart.dart';

class HomeAnalytics extends StatelessWidget {
  const HomeAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChartNCByMonth(),
          ChartNCByStatus(),
        ],
      ),
    );
  }
}
