import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/helpers/graph_parser.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:flutter/material.dart';
class WorkoutCard extends StatelessWidget {
  final Workout workout;

 
  const WorkoutCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔺 Placeholder for workout visual
         /*WorkoutGraph(
  data: extractWorkoutGraphData(workout.xml), // from your workout object
),*/

          // 🧠 Workout details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  workout.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),

                // 🕒 Duration & TSS
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.blueAccent),
                        const SizedBox(width: 6),
                        Text(
                          "${workout.durationMinutes}min",
                          style: const TextStyle(color: Colors.blueAccent),
                        )
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        const Icon(Icons.fitness_center, size: 16, color: Colors.blueAccent),
                        const SizedBox(width: 6),
                        Text(
                          "TSS: ${workout.tss}",
                          style: const TextStyle(color: Colors.blueAccent),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
