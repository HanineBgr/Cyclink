// workout_step.dart
class WorkoutStep {
  final int power;            // Power value in watts for this step
  final int duration;         // Duration of the step in seconds
  final int totalDuration;    // Total duration of the workout (in seconds, for now)

  WorkoutStep({
    required this.power, 
    required this.duration,
  }) : totalDuration = duration;  // Set totalDuration to the duration of this step for now
}
