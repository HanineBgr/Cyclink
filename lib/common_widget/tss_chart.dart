import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../common/colo_extension.dart';

class TssChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly training stress',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: [
                  _buildBarData(0, 20.0, TColor.secondaryColor1),
                  _buildBarData(1, 30.0, TColor.secondaryColor2),
                  _buildBarData(2, 25.0, TColor.secondaryColor1),
                  _buildBarData(3, 40.0, TColor.secondaryColor2),
                  _buildBarData(4, 30.0, TColor.secondaryColor1),
                  _buildBarData(5, 50.0, TColor.secondaryColor2),
                  _buildBarData(6, 45.0, TColor.secondaryColor1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(show: false),
          // Adding text inside the bar
          rodStackItems: [
            BarChartRodStackItem(
              0,
              y,
              color,
            ),
          ],
        ),
      ],
    );
  }
}
// adding values inside tha bars of the chart 