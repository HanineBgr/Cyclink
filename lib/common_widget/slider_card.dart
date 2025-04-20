import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:fast_rhino/view/bluetooth/bluetooth_settings.dart';
import 'package:flutter/material.dart';
import '../common/colo_extension.dart';
import '../helpers/workout_parser.dart'; 
import '../models/Workout/workout.dart';
import '../view/Workout/trainingSession.dart'; 

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
          showDialog(
            context: context,
            builder: (_) => BluetoothPopupDialog(
              onConnected: (trainerId) {
                Navigator.pop(context); // Fermer le popup

                // Aller vers l'écran LiveSession avec l'entraînement sélectionné
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiveSessionScreen(
                      intervals: parseWorkoutXml(workout.xml),
                      ftmsController: ftmsController,
                    ),
                  ),
                );
              },
            ),
          );
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
