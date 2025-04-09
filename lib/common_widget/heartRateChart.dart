import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PowerHeartchart extends StatefulWidget {
  const PowerHeartchart({super.key});

  @override
  _PowerHeartchartState createState() => _PowerHeartchartState();
}

class _PowerHeartchartState extends State<PowerHeartchart> {
  String _selectedChart = ''; // To store the selected chart name

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add some padding to move the title to the right
          Padding(
            padding: const EdgeInsets.only(left: 16.0 , top: 4,), // Adjust the left padding value
            child: const Text(
              "Power & heart rate",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Display the selected chart name
          if (_selectedChart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected chart: $_selectedChart',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          AspectRatio(
            aspectRatio: 1.8,
            child: GestureDetector(
              onTapUp: (details) {
                // Handle tap on chart to determine which chart is selected
                setState(() {
                  double tappedX = details.localPosition.dx;

                  // Define the zones for each chart based on the X position
                  if (tappedX < 120) {
                    _selectedChart = 'Power Chart'; // Blue
                  } else if (tappedX >= 120 && tappedX < 240) {
                    _selectedChart = 'Heart Rate Chart'; // Red
                  } else {
                    _selectedChart = 'Cadence Chart'; // Yellow
                  }
                });
              },
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 35,
                        getTitlesWidget: (value, _) => const SizedBox.shrink(),
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 50,
                        getTitlesWidget: (value, _) => const SizedBox.shrink(),
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          // Check if the value is the last point in the X-axis
                          if (value == 6) {
                            return const Text(
                              '',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            );
                          }
                          return const SizedBox.shrink(); // Otherwise, no title
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false), // Removed black border
                  lineBarsData: [
                    // Power Chart (Blue)
                    LineChartBarData(
                      isCurved: true,
                      spots: [
                        FlSpot(0, 40),
                        FlSpot(1, 20),
                        FlSpot(2, 60),
                        FlSpot(3, 90),
                        FlSpot(4, 20),
                        FlSpot(5, 70),
                        FlSpot(6, 40),
                      ],
                      color: Colors.blue.withOpacity(0.3),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                    // Heart Rate Chart (Red)
                    LineChartBarData(
                      isCurved: true,
                      spots: [
                        FlSpot(0, 50),
                        FlSpot(1, 70),
                        FlSpot(2, 40),
                        FlSpot(3, 60),
                        FlSpot(4, 80),
                        FlSpot(5, 60),
                        FlSpot(6, 70),
                      ],
                      color: Colors.pinkAccent.withOpacity(0.2),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                    // Cadence Chart (Yellow)
                    LineChartBarData(
                      isCurved: true,
                      spots: [
                        FlSpot(0, 20),
                        FlSpot(1, 10),
                        FlSpot(2, 30),
                        FlSpot(3, 50),
                        FlSpot(4, 80),
                        FlSpot(5, 20),
                        FlSpot(6, 40),
                      ],
                      color: Color.fromARGB(255, 227, 223, 108).withOpacity(0.2),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
