import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

import 'workoutInterval.dart';      
import 'workout_step.dart';         
import 'workout_segment.dart';      

class Workout {
  final String name;
  final String description;
  final String author;
  final int totalDuration;
  final List<IntervalWorkout> intervals;
  final List<WorkoutStep> steps;

  Workout({
    required this.name,
    required this.description,
    required this.author,
    required this.totalDuration,
    required this.intervals,
    required this.steps,
  });

  factory Workout.fromXml(XmlDocument document) {
    final root = document.rootElement;
    final workoutElement = root.findElements('workout').first;

    int totalDuration = 0;
    final intervals = <IntervalWorkout>[];  
    final steps = <WorkoutStep>[];

    // Warmup
    final warmup = workoutElement.getElement('Warmup');
    if (warmup != null) {
      final duration = int.parse(warmup.getAttribute('Duration') ?? '0');
      final powerLow = double.parse(warmup.getAttribute('PowerLow') ?? '0');
      final powerHigh = double.parse(warmup.getAttribute('PowerHigh') ?? '0');
      final avgPower = ((powerLow + powerHigh) / 2 * 100).round();

      steps.add(WorkoutStep(duration: duration, power: avgPower, type: 'warmup'));
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
        intervals.add(IntervalWorkout(                      
          onDuration: onDuration,
          offDuration: offDuration,
          onPower: onPower,
          offPower: offPower,
        ));
        steps.add(WorkoutStep(duration: onDuration, power: (onPower * 100).round(), type: 'interval'));
        steps.add(WorkoutStep(duration: offDuration, power: (offPower * 100).round(), type: 'rest'));
        totalDuration += onDuration + offDuration;
      }
    }

    // Cooldown
    final cooldown = workoutElement.getElement('Cooldown');
    if (cooldown != null) {
      final duration = int.parse(cooldown.getAttribute('Duration') ?? '0');
      final powerLow = double.parse(cooldown.getAttribute('PowerLow') ?? '0');
      final powerHigh = double.parse(cooldown.getAttribute('PowerHigh') ?? '0');
      final avgPower = ((powerLow + powerHigh) / 2 * 100).round();

      steps.add(WorkoutStep(duration: duration, power: avgPower, type: 'cooldown'));
      totalDuration += duration;
    }

    return Workout(
      name: root.getElement('name')?.innerText ?? 'Unnamed Workout',
      description: root.getElement('description')?.innerText ?? '',
      author: root.getElement('author')?.innerText ?? 'Unknown',
      intervals: intervals,  
      totalDuration: totalDuration,
      steps: steps,
    );
  }

  List<WorkoutSegment> toSegments() {
    final segments = <WorkoutSegment>[];
    double currentTime = 0;

    for (final step in steps) {
      segments.add(WorkoutSegment(
        start: currentTime,
        duration: step.duration.toDouble(),
        power: step.power / 100,
        color: _getSegmentColor(step.type),
      ));
      currentTime += step.duration;
    }

    return segments;
  }

  Color _getSegmentColor(String type) {
    switch (type.toLowerCase()) {
      case 'warmup':
        return Colors.orange.shade300;
      case 'cooldown':
        return Colors.blue.shade300;
      case 'interval':
        return Colors.red.shade400;
      case 'rest':
        return Colors.green.shade200;
      default:
        return Colors.grey.shade300;
    }
  }
}
