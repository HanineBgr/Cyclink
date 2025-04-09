import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PowerChart extends StatefulWidget {
  const PowerChart({super.key});

  @override
  State<PowerChart> createState() => _PowerChartState();
}

class _PowerChartState extends State<PowerChart> {
  List<double> barHeights = [0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        barHeights = [75, 175, 200, 250];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.start,
            groupsSpace: 0,
            maxY: 300,
            minY: 0,
            barGroups: List.generate(4, (index) {
              final colors = [
                const Color(0xFFADD8FF),
                const Color(0xFF91E6A7),
                const Color(0xFFF3F272),
                const Color(0xFFFFC04D),
              ];
              return BarChartGroupData(
                x: index,
                barsSpace: 0,
                barRods: [
                  BarChartRodData(
                    toY: barHeights[index],
                    width: 49,
                    color: colors[index],
                    borderRadius: BorderRadius.zero,
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 320,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ],
              );
            }),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
              drawVerticalLine: false,
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 100,
                  getTitlesWidget: (value, meta) {
                    if (value == 150) {
                      return Text(
                        'FTP\n150',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${value.toInt()} ',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
          swapAnimationDuration: const Duration(milliseconds: 800),
          swapAnimationCurve: Curves.easeOutCubic,
        ),
      ),
    );
  }
}