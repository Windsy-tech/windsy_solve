import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/core/common/error_text.dart';
import 'package:windsy_solve/core/common/loader.dart';
import 'package:windsy_solve/features/analytics/controller/analytics_controller.dart';

class ChartNCByMonth extends ConsumerStatefulWidget {
  const ChartNCByMonth({super.key});

  @override
  ConsumerState<ChartNCByMonth> createState() => _ChartNCByMonthState();
}

class _ChartNCByMonthState extends ConsumerState<ChartNCByMonth> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      child: AspectRatio(
        aspectRatio: 1.70,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: theme.colorScheme.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Non-Conformities by Month",
                        style: theme.textTheme.titleSmall,
                      ),
                      SizedBox(
                        width: 60,
                        height: 20,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: const Text("Component"),
                            value: year,
                            isDense: true,
                            isExpanded: true,
                            dropdownColor: const Color(0xff37434d),
                            items: yearList.map((int year) {
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Text(
                                  year.toString(),
                                  style: theme.textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: (Object? val) {
                              setState(() {
                                year = val! as int;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ref.watch(getNCCountByMonthProvider(year)).when(
                          data: (data) {
                            spots?.clear();
                            maxYValue = 1;

                            for (int i = 1; i <= 12; i++) {
                              spots?.add(
                                FlSpot(
                                  i.toDouble(),
                                  data[i]?.toDouble() ?? 0,
                                ),
                              );
                              if (data[i] != null && data[i]! > maxYValue) {
                                maxYValue =
                                    data[i]!; // Update maxYValue if needed.
                              }
                            }
                            return LineChart(
                              showAvg ? avgData() : mainData(),
                            );
                          },
                          error: (e, s) => ErrorText(error: e.toString()),
                          loading: () => const Loader(),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Jan', style: style);
        break;
      case 2:
        text = const Text('Feb', style: style);
        break;
      case 3:
        text = const Text('Mar', style: style);
        break;
      case 4:
        text = const Text('Apr', style: style);
        break;
      case 5:
        text = const Text('May', style: style);
        break;
      case 6:
        text = const Text('Jun', style: style);
        break;
      case 7:
        text = const Text('Jul', style: style);
        break;
      case 8:
        text = const Text('Aug', style: style);
        break;
      case 9:
        text = const Text('Sept', style: style);
        break;
      case 10:
        text = const Text('Oct', style: style);
        break;
      case 11:
        text = const Text('Nov', style: style);
        break;
      case 12:
        text = const Text('Dec', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    String text =
        value.toInt().toString(); // Convert the double value to an integer

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: maxYValue / 5 + (maxYValue.toDouble() / 10),
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 3,
            getTitlesWidget: bottomTitleWidgets,
          ),
          axisNameWidget: const Text(
            "Month",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff67727d),
            ),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxYValue != 0
                ? maxYValue / 5 + (maxYValue.toDouble() / 10)
                : 2,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 35,
          ),
          axisNameWidget: const Text(
            "No. of NC's",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff67727d),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: maxYValue.toDouble() + (maxYValue.toDouble() / 2),
      lineBarsData: [
        LineChartBarData(
          show: spots!.isNotEmpty ? true : false,
          spots: spots!,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: maxYValue / 5,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 3,
            getTitlesWidget: bottomTitleWidgets,
          ),
          axisNameWidget: const Text(
            "Month",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff67727d),
            ),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxYValue != 0 ? maxYValue / 5 : 2,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 25,
          ),
          axisNameWidget: const Text(
            "No. of NC\'s",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff67727d),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: maxYValue.toDouble(),
      lineBarsData: [
        LineChartBarData(
          show: spots!.isNotEmpty ? true : false,
          spots: spots!,
          isCurved: false,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }
}
