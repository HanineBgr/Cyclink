import 'dart:math' as math;

import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/common_widget/slider_card.dart';
import 'package:fast_rhino/common_widget/step_detail_row.dart';
import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class WorkoutDetailView extends StatelessWidget {
  final Workout workout;
  final List<WorkoutInterval> intervals;
  final List<Map<String, String>> essentialSteps;
  final double ftp;
  final FtmsController ftmsController;

  const WorkoutDetailView({
    super.key,
    required this.workout,
    required this.intervals,
    required this.essentialSteps,
    required this.ftp,
    required this.ftmsController,
  });

  @override
  Widget build(BuildContext context) {
    double sum4thPower = 0;
    int totalSeconds = 0;

    for (var interval in intervals) {
      final watts = (interval.power / 100.0) * ftp;
      final durationSeconds = (interval.duration * 60).toInt();
      sum4thPower += durationSeconds * math.pow(watts, 4);
      totalSeconds += durationSeconds;
    }

    final np = totalSeconds > 0 ? math.pow(sum4thPower / totalSeconds, 0.25) : 0.0;
    final ifFactor = ftp > 0 ? np / ftp : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ReadMoreText(
          textAlign: TextAlign.justify,
          workout.description,
          colorClickableText: TColor.primaryColor1,
          style: TextStyle(color: TColor.gray, fontSize: 14),
        ),
        const SizedBox(height: 25),
        WorkoutGraphBar(intervals: intervals),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMetricTile("Duration", "${workout.durationMinutes} min", Icons.timer),
            _buildMetricTile("TSS", workout.tss.toString(), Icons.bolt),
            _buildMetricTile("NP", np.toStringAsFixed(0), Icons.bar_chart),
            _buildMetricTile("IF", ifFactor.toStringAsFixed(2), Icons.speed),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Workout Structure", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
            Text("${essentialSteps.length} Steps", style: TextStyle(color: TColor.gray, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        ...essentialSteps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return StepDetailRow(
            sObj: {
              "no": "${index + 1}".padLeft(2, "0"),
              "title": step["title"]!,
              "detail": step["detail"]!,
            },
            isLast: index == essentialSteps.length - 1,
          );
        }).toList(),
        const SizedBox(height: 25),
        SessionSliderCard(workout: workout, ftmsController: ftmsController),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: TColor.primaryColor1),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TColor.black)),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
