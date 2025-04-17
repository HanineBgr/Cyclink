import 'package:fast_rhino/common_widget/round_button.dart';
import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/helpers/graph_parser.dart';
import 'package:flutter/material.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:fast_rhino/common/colo_extension.dart';


class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        leading: BackButton(color: TColor.primaryColor1),
        title: Text(
          workout.name,
          style: TextStyle(
              color: TColor.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout Graph
            WorkoutGraph(data: extractWorkoutGraphData(workout.xml)),
            const SizedBox(height: 16),

            // Title
            Text(
              workout.name,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: TColor.primaryColor1),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              textAlign: TextAlign.justify,
              workout.description,
              style: TextStyle(
                
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // Metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricTile("TSS", workout.tss.toString(), Icons.bolt),
                _buildMetricTile("Duration", "${workout.durationMinutes} min", Icons.timer),
                _buildMetricTile("FTP", "255", Icons.speed), // Replace FTP dynamically if needed
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RoundButton(
                height: 25,
                title: "Start Session",
                onPressed: () {
                  // start session logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: TColor.primaryColor1),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: TColor.black),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}
