import 'package:fast_rhino/common_widget/workout_card.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:flutter/material.dart';

class WorkoutListView extends StatelessWidget {
  final List<Workout> workouts;
  final Function(Workout) onSelect;

  const WorkoutListView({super.key, required this.workouts, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: workouts.map((workout) {
        return GestureDetector(
          onTap: () => onSelect(workout),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: WorkoutCard(workout: workout),
          ),
        );
      }).toList(),
    );
  }
}
