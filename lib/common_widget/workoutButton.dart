import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:fast_rhino/view/bluetooth/bluetooth_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../common/colo_extension.dart';
import '../helpers/workout_parser.dart';
import '../models/Workout/workout.dart';
import '../view/Workout/trainingSession.dart';

class startWorkoutButton extends StatelessWidget {
  final Workout workout;
  final FtmsController ftmsController;

  const startWorkoutButton({
    super.key,
    required this.workout,
    required this.ftmsController,
  });

  Future<void> _handleBluetoothFlow(BuildContext context) async {
    // 🔐 Request system-level Bluetooth permissions
    final permissions = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.locationWhenInUse, 
    ].request();

    final allGranted = permissions.values.every((status) => status.isGranted);

    if (allGranted) {
      _showBluetoothPopup(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bluetooth permissions are required to start a workout."),
        ),
      );
    }
  }

  void _showBluetoothPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BluetoothPopupDialog(
        onConnected: (trainerId) {
          Navigator.pop(context); // close popup
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _handleBluetoothFlow(context),
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
