import 'package:flutter/material.dart';
import 'package:windsy_solve/features/analytics/widgets/nc_by_month_chart.dart';
import 'package:windsy_solve/features/analytics/widgets/nc_by_status_chart.dart';

class HomeAnalytics extends StatelessWidget {
  const HomeAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Analytics",
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),
          const ChartNCByMonth(),
          const ChartNCByStatus(),
        ],
      ),
    );
  }
}
