import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:flutter/material.dart';
import '../helpers/zone_helper.dart';

class WorkoutGraphBar extends StatelessWidget {
  final List<WorkoutInterval> intervals;
  final double maxHeight;

  const WorkoutGraphBar({
    super.key,
    required this.intervals,
    this.maxHeight = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: intervals.map((interval) {
              final height = maxHeight * (interval.power / 250); // scale to FTP
              final color = getZoneColor(interval.power);
              final flex = (interval.duration * 100).toInt();

              return Expanded(
                flex: flex,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: height.clamp(10.0, maxHeight),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
