import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutGraph extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const WorkoutGraph({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.start,
          maxY: 6, 
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barGroups: _generateContinuousBarGroups(data),
          barTouchData: BarTouchData(enabled: false),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateContinuousBarGroups(List<Map<String, dynamic>> data) {
    return List.generate(data.length, (index) {
      final item = data[index];
      final power = (item['power'] ?? 0.0) as double;
      final type = (item['type'] ?? 'SteadyState') as String;

      return BarChartGroupData(
        x: index,
        barsSpace: 0,
        barRods: [
          BarChartRodData(
            toY: power * 3, 
            width: 10,
            borderRadius: BorderRadius.zero,
            color: getColorForType(type),
          )
        ],
      );
    });
  }

  Color getColorForType(String type) {
    switch (type) {
      case 'Warmup':
        return Colors.orange;
      case 'Cooldown':
        return Colors.blue.shade400;
      case 'IntervalsT':
        return Colors.red;
      case 'SteadyState':
        return Colors.green.shade300;
      default:
        return Colors.grey;
    }
  }
}
