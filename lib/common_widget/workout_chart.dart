import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:flutter/material.dart';
import '../helpers/zone_helper.dart';

class WorkoutGraphBar extends StatelessWidget {
  final List<WorkoutInterval> intervals;

  const WorkoutGraphBar({super.key, required this.intervals});

  @override
  Widget build(BuildContext context) {
    final totalDuration = intervals.fold(0.0, (sum, i) => sum + i.duration);
    const maxHeight = 50.0; // Increased from 40.0 to 100.0

    return SizedBox(
      height: maxHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: intervals.map((interval) {
          final height = maxHeight * (interval.power / 250); // 250% FTP
          final color = getZoneColor(interval.power);
          final flex = (interval.duration * 100).toInt();

          return Expanded(
            flex: flex,
            child: Container(
              height: height.clamp(10.0, maxHeight), // Increased min height too
              margin: const EdgeInsets.symmetric(horizontal: 0.5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
