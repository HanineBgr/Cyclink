import 'package:fast_rhino/helpers/power_zone.dart';


class WorkoutInterval {
  final String type;
  final double duration; // en minutes
  final double power; // moyenne % FTP
  final PowerZone zone;
  final double startPower;
  final double endPower;
  final bool isRamp;

  WorkoutInterval({
    required this.type,
    required this.duration,
    required this.power,
    required this.zone,
    required this.startPower,
    required this.endPower,
    required this.isRamp,
  });
}
