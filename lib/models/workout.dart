import 'package:fast_rhino/models/interval.dart';
import 'package:xml/xml.dart';

class Workout {
  final String name;
  final String description;
  final String author;
  final int totalDuration;
  final List<Interval> intervals;

  Workout({
    required this.name,
    required this.description,
    required this.author,
    required this.totalDuration,
    required this.intervals,
  });

  factory Workout.fromXml(XmlDocument document) {
    final root = document.rootElement;
    final workoutElement = root.findElements('workout').first;

    int totalDuration = 0;
    final intervals = <Interval>[];

    // Warmup
    final warmup = workoutElement.getElement('Warmup');
    if (warmup != null) {
      final duration = int.parse(warmup.getAttribute('Duration') ?? '0');
      totalDuration += duration;
    }

    // IntervalsT
    final intervalsT = workoutElement.getElement('IntervalsT');
    if (intervalsT != null) {
      final repeat = int.parse(intervalsT.getAttribute('Repeat') ?? '1');
      final onDuration = int.parse(intervalsT.getAttribute('OnDuration') ?? '0');
      final offDuration = int.parse(intervalsT.getAttribute('OffDuration') ?? '0');
      final onPower = double.parse(intervalsT.getAttribute('OnPower') ?? '0.0');
      final offPower = double.parse(intervalsT.getAttribute('OffPower') ?? '0.0');

      for (int i = 0; i < repeat; i++) {
        intervals.add(Interval(
          onDuration: onDuration,
          offDuration: offDuration,
          onPower: onPower,
          offPower: offPower,
        ));
        totalDuration += onDuration + offDuration;
      }
    }

    // Cooldown
    final cooldown = workoutElement.getElement('Cooldown');
    if (cooldown != null) {
      final duration = int.parse(cooldown.getAttribute('Duration') ?? '0');
      totalDuration += duration;
    }

    return Workout(
      name: root.getElement('name')?.innerText ?? 'Unnamed Workout',
      description: root.getElement('description')?.innerText ?? '',
      author: root.getElement('author')?.innerText ?? 'Unknown',
      intervals: intervals,
      totalDuration: totalDuration,
    );
  }
}
