import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutGraph extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const WorkoutGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .map((point) => FlSpot(
                        point['time'].toDouble() / 60, // show minutes
                        point['power'].toDouble(),
                      ))
                  .toList(),
              isCurved: false,
              barWidth: 2,
              color: Colors.blueAccent,
              dotData: FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }
}
