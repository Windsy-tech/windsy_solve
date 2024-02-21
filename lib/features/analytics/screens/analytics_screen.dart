import 'package:flutter/material.dart';
import 'package:windsy_solve/features/analytics/widgets/nc_by_month_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: const ChartNCByMonth(),
    );
  }
}
