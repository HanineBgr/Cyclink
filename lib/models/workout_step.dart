class WorkoutStep {
  final int power;            // Power value in watts for this step
  final int duration;         // Duration of the step in seconds
  final int totalDuration;    // Total duration of the workout (in seconds, for now)
  final String type;          // Type: warmup, interval, rest, cooldown

  WorkoutStep({
    required this.power, 
    required this.duration,
    required this.type,
  }) : totalDuration = duration;
}