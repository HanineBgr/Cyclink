import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:flutter/material.dart';
import '../helpers/zone_helper.dart';

class WorkoutGraphBar extends StatelessWidget {
  final List<WorkoutInterval> intervals;
  final double maxHeight;

  const WorkoutGraphBar({
    super.key,
    required this.intervals,
    this.maxHeight = 40.0, // height
  });

  @override
  Widget build(BuildContext context) {
    final totalDuration = intervals.fold<double>(0, (sum, i) => sum + i.duration);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 📊 Bar Graph
        SizedBox(
          height: maxHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: intervals.map((interval) {
              final powerRatio = interval.power / 100.0; // power as %FTP
              final barHeight = powerRatio * maxHeight;
              final flex = (interval.duration / totalDuration * 1000).toInt();
              final color = getZoneColor(interval.power); // your original zone color

              return Expanded(
                flex: flex,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  height: barHeight.clamp(10.0, maxHeight),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),

        // ⏱ Time Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("0:00", style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text("30:00", style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text("60:00", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
