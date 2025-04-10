/*import 'package:flutter/material.dart';
import 'package:fast_rhino/models/workout.dart';

class WorkoutChart extends StatelessWidget {
  final Workout workout;

  const WorkoutChart({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthPerSecond = 1.5;
    return CustomPaint(
      size: Size(double.infinity, 200),
      painter: WorkoutChartPainter(workout),
    );
  }
}

class WorkoutChartPainter extends CustomPainter {
  final Workout workout;

  WorkoutChartPainter(this.workout);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    double startX = 0.0;
    double widthPerSecond = size.width / workout.totalDuration;

    for (final segment in workout.toSegments()) {
      final blockWidth = segment.duration * widthPerSecond;
      paint.color = segment.color;
      canvas.drawRect(
        Rect.fromLTWH(startX, 0, blockWidth, size.height),
        paint,
      );
      startX += blockWidth;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} */