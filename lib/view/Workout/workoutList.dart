// lib/view/Workout/workoutList.dart
import 'package:fast_rhino/common_widget/workout_card.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:flutter/material.dart';

class WorkoutListView extends StatelessWidget {
  final List<Workout> workouts;
  final void Function(Workout) onSelect;
  final ScrollController scrollController;

  const WorkoutListView({
    super.key,
    required this.workouts,
    required this.onSelect,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final w = workouts[index];
        return GestureDetector(
          onTap: () => onSelect(w),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: WorkoutCard(workout: w),
          ),
        );
      },
    );
  }
}
