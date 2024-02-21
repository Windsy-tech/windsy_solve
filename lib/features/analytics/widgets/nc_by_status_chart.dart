import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/analytics/controller/analytics_controller.dart';

class ChartNCByStatus extends ConsumerStatefulWidget {
  const ChartNCByStatus({super.key});

  @override
  ConsumerState<ChartNCByStatus> createState() => _ChartNCByStatusState();
}

class _ChartNCByStatusState extends ConsumerState<ChartNCByStatus> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  List<FlSpot>? spots = [];

  int maxYValue = 1;

  List<int> yearList = [2021, 2022, 2023, 2024];
  bool switchVal = true;
  int year = 2024;

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: ref.watch(getNCCountByStatusProvider(year)).when(
                    data: (data) {
                      print("Data: $data");
                      return pieChart(data);
                    },
                    error: (e, s) => ErrorText(
                      error: e.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                text: 'Open',
                isOpen: true,
              ),
              const SizedBox(
                height: 4,
              ),
              Indicator(
                text: 'Closed',
                isOpen: false,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  PieChart pieChart(Map<String, int> data) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: showingSections(data),
      ),
    );
  }

  List<PieChartSectionData> showingSections(Map<String, int> data) {
    return data.entries
        .map(
          (e) => PieChartSectionData(
            color: e.key == 'Open' ? Colors.red : Colors.green,
            value: e.value.toDouble(),
            title: '${e.value}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
        .toList();
  }

  Indicator({required String text, required bool isOpen}) {
    return Row(
      children: <Widget>[
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: isOpen ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
