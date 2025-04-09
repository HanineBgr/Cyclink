import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../common/colo_extension.dart';

class PerformanceChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<FlSpot> CTL = [
      FlSpot(0, 20),
      FlSpot(1, 30),
      FlSpot(2, 25),
      FlSpot(3, 40),
      FlSpot(4, 30),
      FlSpot(5, 50),
      FlSpot(6, 45),
    ];

    final List<FlSpot> ATL = [
      FlSpot(0, 15),
      FlSpot(1, 25),
      FlSpot(2, 20),
      FlSpot(3, 35),
      FlSpot(4, 28),
      FlSpot(5, 48),
      FlSpot(6, 40),
    ];
   final List<FlSpot> TSB = List.generate(CTL.length, (index) {
  double tsbValue = CTL[index].y - ATL[index].y;
  return FlSpot(CTL[index].x, tsbValue); 
});
    final List<FlSpot> allSpots = [...CTL, ...ATL, ...TSB];
    final double minY = allSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final double maxY = allSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final double midY = (minY + maxY) / 2;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance chart',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value.toStringAsFixed(1) == minY.toStringAsFixed(1) ||
                            value.toStringAsFixed(1) == midY.toStringAsFixed(1) ||
                            value.toStringAsFixed(1) == maxY.toStringAsFixed(1)) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                              textAlign: TextAlign.right,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: midY,
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.centerRight,
                        style: TextStyle(fontSize: 10, color: Colors.black45),
                        labelResolver: (line) => 'Mid',  
                      ),
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    spots: CTL,
                    color: TColor.primaryColor2,
                    barWidth: 2,
                  ),
                  LineChartBarData(
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    spots: ATL,
                    color: Colors.red,
                    barWidth: 2,
                  ),
                   LineChartBarData(
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    spots: TSB,
                    color: Colors.green,
                    barWidth: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/// display mid value on the chart ( y axis)
/// CTL (Chronic Training Load) : Bleu (souvent un bleu moyen à foncé)
/// ATL (Acute Training Load) : Rouge ou rose
/// TSB (Training Stress Balance) : Vert (valeurs positives) et jaune/orange (valeurs négatives)
