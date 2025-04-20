import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:flutter/material.dart';
import '../helpers/workout_parser.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  const WorkoutCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final intervals = parseWorkoutXml(workout.xml);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color.fromARGB(40, 0, 0, 0), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.white,
              child: WorkoutGraphBar(intervals: intervals),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workout.name, 
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(workout.description, maxLines: 2, 
                  style: const TextStyle(color: Color.fromARGB(136, 54, 54, 54), fontSize: 14),
                  overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.blue),
                      const SizedBox(width: 6),
                      Text('${workout.durationMinutes} min',
                      style: TextStyle(color: const Color.fromARGB(255, 48, 48, 48), fontSize: 14),
                      
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.flash_on, size: 16, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text('TSS: ${workout.tss}', 
                      style: TextStyle(color: const Color.fromARGB(255, 48, 48, 48), fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
