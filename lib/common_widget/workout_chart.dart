import 'package:flutter/material.dart';
import '../models/workout_segment.dart';

class WorkoutChart extends StatelessWidget {
  final List<WorkoutSegment> segments;
  final double totalDuration;

  const WorkoutChart({
    Key? key,
    required this.segments,
    required this.totalDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: CustomPaint(
        painter: WorkoutChartPainter(segments, totalDuration),
      ),
    );
  }
}

class WorkoutChartPainter extends CustomPainter {
  final List<WorkoutSegment> segments;
  final double totalDuration;

  WorkoutChartPainter(this.segments, this.totalDuration);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final baseLineY = size.height * 0.75;
    final barMaxHeight = size.height * 0.5;

    for (final segment in segments) {
      final x = (segment.start / totalDuration) * size.width;
      final width = (segment.duration / totalDuration) * size.width;
      final height = barMaxHeight * segment.power;

      paint.color = segment.color;
      canvas.drawRect(
        Rect.fromLTWH(x, baseLineY - height, width, height),
        paint,
      );
    }

    paint.color = Colors.purple.shade100;
    canvas.drawRect(
      Rect.fromLTWH(0, baseLineY, size.width, 4),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
