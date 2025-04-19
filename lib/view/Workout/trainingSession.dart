/*import 'dart:async';
import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:fast_rhino/helpers/graph_parser.dart';
import 'package:fast_rhino/providers/auth_provider.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LiveSessionScreen extends StatefulWidget {
  final Workout workout;
  final FtmsController ftmsController;

  const LiveSessionScreen({super.key, required this.workout, required this.ftmsController});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  int currentStepIndex = 0;
  late List<_WorkoutStep> workoutSteps;
  Timer? stepTimer;

  @override
  void initState() {
    super.initState();
    _buildWorkoutSteps();
    _startNextStep();
  }

  void _buildWorkoutSteps() {
    // This should be replaced by actual XML parsing to build steps dynamically
    workoutSteps = [
      _WorkoutStep(label: 'Warmup', durationSec: 600, ftpPercentage: 0.6),
      _WorkoutStep(label: 'Interval 1', durationSec: 180, ftpPercentage: 1.2),
      _WorkoutStep(label: 'Recovery', durationSec: 60, ftpPercentage: 0.65),
      _WorkoutStep(label: 'Interval 2', durationSec: 180, ftpPercentage: 1.2),
      _WorkoutStep(label: 'Recovery', durationSec: 60, ftpPercentage: 0.65),
      _WorkoutStep(label: 'Cooldown', durationSec: 300, ftpPercentage: 0.5),
    ];
  }

  void _startNextStep() {
    if (currentStepIndex >= workoutSteps.length) return;

    final userFtp = Provider.of<AuthProvider>(context, listen: false).ftp;
    final step = workoutSteps[currentStepIndex];
    final targetWatts = (userFtp * step.ftpPercentage).round();

    widget.ftmsController.sendTargetPower(targetWatts);

    stepTimer = Timer(Duration(seconds: step.durationSec), () {
      setState(() => currentStepIndex++);
      _startNextStep();
    });
  }

  @override
  void dispose() {
    stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = currentStepIndex < workoutSteps.length ? workoutSteps[currentStepIndex] : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricTile("POWER LAP", "187"),
                  _buildMetricTile("POWER", "${step != null ? (Provider.of<AuthProvider>(context).ftp * step.ftpPercentage).round() : '--'}"),
                  _buildMetricTile("INTERVAL TIME", "${step != null ? step.durationSec ~/ 60 : '--'}:00"),
                  _buildMetricTile("HEART RATE", "89", color: Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricTile("TARGET", step != null ? "${(step.ftpPercentage * 100).toInt()}%" : '--'),
                  _buildMetricTile("ELAPSED TIME", "00:01:00"),
                  _buildMetricTile("CADENCE", "102"),
                  _buildMetricTile("SPEED", "29.5"),
                  _buildMetricTile("DISTANCE", "381"),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                step != null ? step.label : "Session Complete!",
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Expanded(child: WorkoutGraph(data: extractWorkoutGraphData(widget.workout.xml)))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, {Color color = Colors.white}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white60),
        ),
      ],
    );
  }
}

class _WorkoutStep {
  final String label;
  final int durationSec;
  final double ftpPercentage;

  _WorkoutStep({required this.label, required this.durationSec, required this.ftpPercentage});
}
*/