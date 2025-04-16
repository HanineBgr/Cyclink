import 'package:flutter/material.dart';

class WorkoutSegment {
  final double start;
  final double duration;
  final double power;
  final Color color;

  WorkoutSegment({
    required this.start,
    required this.duration,
    required this.power,
    required this.color,
  });
}
