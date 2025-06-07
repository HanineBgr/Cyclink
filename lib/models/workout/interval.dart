class WorkoutInterval {
  final int duration; // in minutes
  final int power;    // as a percentage of FTP
  final String type;
  final String zone;
  final int startPower;
  final int endPower;
  final bool isRamp;

  WorkoutInterval({
    required this.duration,
    required this.power,
    required this.type,
    required this.zone,
    required this.startPower,
    required this.endPower,
    required this.isRamp,
  });
}