// lib/view/Workout/WorkoutLibrary.dart
import 'dart:math' as math;
import 'package:fast_rhino/common_widget/search_bar.dart';
import 'package:fast_rhino/common_widget/step_detail_row.dart';
import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:fast_rhino/providers/workout_provider.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:fast_rhino/view/Workout/workoutDetail.dart';
import 'package:flutter/material.dart';
   import 'package:fast_rhino/common_widget/round_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:readmore/readmore.dart';
import 'package:xml/xml.dart';
import 'package:fast_rhino/providers/auth_provider.dart';
import '../../common/colo_extension.dart';

class WorkoutLibrary extends StatelessWidget {
  final List<Map<String, dynamic>> workouts = [
    {
      'title': 'Threshold Over/Under',
      'description': 'This demanding workout improves lactate clearance and mental toughness through oscillating intervals.',
      'duration': 89,
      'tss': 101,
      'chart': WorkoutBarChart(type: 1),
      'intervals': [
        WorkoutInterval(duration: 10, power: 60, type: 'Warmup', zone: 'Z2', startPower: 60, endPower: 70, isRamp: false),
        WorkoutInterval(duration: 20, power: 80, type: 'Main', zone: 'Z4', startPower: 80, endPower: 90, isRamp: false),
        WorkoutInterval(duration: 15, power: 70, type: 'Cooldown', zone: 'Z2', startPower: 70, endPower: 60, isRamp: false),
      ],
      'essentialSteps': [
        {'title': 'Warmup', 'detail': '10 min at 60% FTP'},
        {'title': 'Main Set', 'detail': '20 min at 80% FTP'},
        {'title': 'Cooldown', 'detail': '15 min at 70% FTP'},
      ],
    },
    {
      'title': 'Crescendo Threshold',
      'description': 'This advanced threshold session features progressive intervals for maximum adaptation.',
      'duration': 75,
      'tss': 88,
      'chart': WorkoutBarChart(type: 2),
      'intervals': [
        WorkoutInterval(duration: 15, power: 65, type: 'Warmup', zone: 'Z2', startPower: 60, endPower: 70, isRamp: false),
        WorkoutInterval(duration: 30, power: 85, type: 'Main', zone: 'Z4', startPower: 80, endPower: 90, isRamp: true),
        WorkoutInterval(duration: 10, power: 60, type: 'Cooldown', zone: 'Z1', startPower: 60, endPower: 50, isRamp: false),
      ],
      'essentialSteps': [
        {'title': 'Warmup', 'detail': '15 min at 65% FTP'},
        {'title': 'Main Set', 'detail': '30 min ramp from 80% to 90% FTP'},
        {'title': 'Cooldown', 'detail': '10 min at 60% FTP'},
      ],
    },
    {
      'title': 'Endurance Ride',
      'description': 'A steady-state ride to build aerobic endurance and stamina for long events.',
      'duration': 120,
      'tss': 110,
      'chart': WorkoutBarChart(type: 3),
      'intervals': [
        WorkoutInterval(duration: 20, power: 60, type: 'Warmup', zone: 'Z2', startPower: 60, endPower: 65, isRamp: false),
        WorkoutInterval(duration: 80, power: 70, type: 'Main', zone: 'Z3', startPower: 70, endPower: 75, isRamp: false),
        WorkoutInterval(duration: 20, power: 60, type: 'Cooldown', zone: 'Z2', startPower: 65, endPower: 60, isRamp: false),
      ],
      'essentialSteps': [
        {'title': 'Warmup', 'detail': '20 min at 60% FTP'},
        {'title': 'Main Set', 'detail': '80 min at 70% FTP'},
        {'title': 'Cooldown', 'detail': '20 min at 60% FTP'},
      ],
    },
    {
      'title': 'Fat Burn',
      'description': 'Burn calories fast with this high-intensity fat burning session.',
      'duration': 60,
      'tss': 70,
      'chart': WorkoutBarChart(type: 4),
      'intervals': [
        WorkoutInterval(duration: 10, power: 55, type: 'Warmup', zone: 'Z1', startPower: 55, endPower: 60, isRamp: false),
        WorkoutInterval(duration: 40, power: 75, type: 'Main', zone: 'Z3', startPower: 75, endPower: 80, isRamp: false),
        WorkoutInterval(duration: 10, power: 55, type: 'Cooldown', zone: 'Z1', startPower: 60, endPower: 55, isRamp: false),
      ],
      'essentialSteps': [
        {'title': 'Warmup', 'detail': '10 min at 55% FTP'},
        {'title': 'Main Set', 'detail': '40 min at 75% FTP'},
        {'title': 'Cooldown', 'detail': '10 min at 55% FTP'},
      ],
    },
    {
      'title': 'Recovery Spin',
      'description': 'Low intensity recovery ride to help your muscles recover and reduce fatigue.',
      'duration': 45,
      'tss': 40,
      'chart': WorkoutBarChart(type: 5),
      'intervals': [
        WorkoutInterval(duration: 10, power: 50, type: 'Warmup', zone: 'Z1', startPower: 50, endPower: 55, isRamp: false),
        WorkoutInterval(duration: 25, power: 60, type: 'Main', zone: 'Z2', startPower: 60, endPower: 65, isRamp: false),
        WorkoutInterval(duration: 10, power: 50, type: 'Cooldown', zone: 'Z1', startPower: 55, endPower: 50, isRamp: false),
      ],
      'essentialSteps': [
        {'title': 'Warmup', 'detail': '10 min at 50% FTP'},
        {'title': 'Main Set', 'detail': '25 min at 60% FTP'},
        {'title': 'Cooldown', 'detail': '10 min at 50% FTP'},
      ],
    },
    {
      'title': 'HIIT Cardio',
      'description': 'High Intensity Interval Training to boost your VO2 max and burn calories.',
      'duration': 50,
      'tss': 85,
      'chart': WorkoutBarChart(type: 6),
      'intervals': [
        WorkoutInterval(duration: 5, power: 60, type: 'Warmup', zone: 'Z2', startPower: 60, endPower: 65, isRamp: false),
        WorkoutInterval(duration: 35, power: 90, type: 'Main', zone: 'Z5', startPower: 90, endPower: 100, isRamp: true),
        WorkoutInterval(duration: 10, power: 60, type: 'Cooldown', zone: 'Z2', startPower: 65, endPower: 60, isRamp: false),
      ],
      'essentialSteps': [
        {'title': 'Warmup', 'detail': '5 min at 60% FTP'},
        {'title': 'Main Set', 'detail': '35 min ramp from 90% to 100% FTP'},
        {'title': 'Cooldown', 'detail': '10 min at 60% FTP'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Workout Library", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        separatorBuilder: (_, __) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return WorkoutCard(
            workout: workout,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      title: Text(workout['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black87),
                    ),
                    backgroundColor: Colors.white,
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: WorkoutDetailViewWithChartAndButton(
                        workout: Workout(
                          id: '1',
                          name: workout['title'],
                          description: workout['description'],
                          durationMinutes: workout['duration'],
                          tss: workout['tss'],
                          category: 'General',
                          xml: '',
                        ),
                        intervals: List<WorkoutInterval>.from(workout['intervals']),
                        essentialSteps: List<Map<String, String>>.from(workout['essentialSteps']),
                        ftp: 250,
                        ftmsController: FtmsController(),
                        chart: workout['chart'],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback onTap;
  const WorkoutCard({super.key, required this.workout, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WorkoutBarChart(type: workout['chart'].type, height: 20),
            const SizedBox(height: 12),
            Text(
              workout['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              workout['description'],
              style: TextStyle(fontSize: 13, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.timer, size: 18, color: Colors.blue.shade400),
                const SizedBox(width: 4),
                Text('${workout['duration']} min', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 16),
                Icon(Icons.flash_on, size: 18, color: Colors.orange.shade400),
                const SizedBox(width: 4),
                Text('TSS: ${workout['tss']}', style: TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutBarChart extends StatelessWidget {
  final int type;
  final double height;
  const WorkoutBarChart({super.key, this.type = 1, this.height = 32});

  @override
  Widget build(BuildContext context) {
    List<Color> colors;
    List<int> pattern;
    switch (type) {
      case 1:
        colors = [Colors.green, Colors.orange, Colors.blue, Colors.orange, Colors.green];
        pattern = [2, 6, 2, 6, 2];
        break;
      case 2:
        colors = [Colors.green, Colors.orange, Colors.green, Colors.orange, Colors.green];
        pattern = [4, 4, 4, 4, 4];
        break;
      case 3:
        colors = [Colors.green, Colors.green, Colors.green, Colors.green, Colors.green];
        pattern = [2, 8, 8, 8, 2];
        break;
      case 4:
        colors = [Colors.orange, Colors.orange, Colors.orange, Colors.orange, Colors.orange];
        pattern = [2, 4, 4, 4, 2];
        break;
      case 5:
        colors = [Colors.blue, Colors.blue, Colors.blue, Colors.blue, Colors.blue];
        pattern = [2, 4, 4, 4, 2];
        break;
      case 6:
        colors = [Colors.red, Colors.orange, Colors.red, Colors.orange, Colors.red];
        pattern = [2, 2, 2, 2, 2];
        break;
      default:
        colors = [Colors.green, Colors.orange, Colors.blue, Colors.orange, Colors.green];
        pattern = [2, 6, 2, 6, 2];
    }

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(colors.length, (i) {
          return Expanded(
            flex: pattern[i],
            child: Container(
              height: (height / 2) + (i % 2 == 0 ? height / 4 : height * 0.625),
              decoration: BoxDecoration(
                color: colors[i],
                borderRadius: BorderRadius.circular(4),
              ),
              margin: EdgeInsets.symmetric(horizontal: 1),
            ),
          );
        }),
      ),
    );
  }
}

class WorkoutDetailViewWithChartAndButton extends StatelessWidget {
  final Workout workout;
  final List<WorkoutInterval> intervals;
  final List<Map<String, String>> essentialSteps;
  final double ftp;
  final FtmsController ftmsController;
  final Widget chart;
  const WorkoutDetailViewWithChartAndButton({
    super.key,
    required this.workout,
    required this.intervals,
    required this.essentialSteps,
    required this.ftp,
    required this.ftmsController,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: chart),
        const SizedBox(height: 20),
        WorkoutDetailView(
          workout: workout,
          intervals: intervals,
          essentialSteps: essentialSteps,
          ftp: ftp,
          ftmsController: ftmsController,
        ),
        const SizedBox(height: 20),
        Center(
          child: RoundButton(
            title: "Start Workout",
            onPressed: () {
             
            },
          ),
        ),
      ],
    );
  }
}
