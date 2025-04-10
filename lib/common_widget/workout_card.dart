import 'package:flutter/material.dart';
import 'package:fast_rhino/models/workout.dart';
import 'package:fast_rhino/common_widget/workout_chart.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  const WorkoutCard({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int durationInMinutes = (workout.totalDuration / 60).round();

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          //WorkoutChart(workout: workout),
          SizedBox(height: 8),
          Text(workout.description),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.timer, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text('$durationInMinutes min'),
                ],
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }
}
