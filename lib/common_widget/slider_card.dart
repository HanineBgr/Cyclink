import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import '../common/colo_extension.dart';
import '../models/Workout/workout.dart';
// import '../view/Workout/trainingSession.dart';

class SessionSliderCard extends StatelessWidget {
  final Workout workout;
  final FtmsController ftmsController;

  const SessionSliderCard({
    super.key,
    required this.workout,
    required this.ftmsController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          // You can add your navigation logic here
          // Navigator.push(...);
          print('Start workout: ${workout.name}');
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text("Start Workout"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          backgroundColor: TColor.primaryColor1,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
