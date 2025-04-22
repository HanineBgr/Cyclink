import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:fast_rhino/view/bluetooth/bluetooth_settings.dart';
import 'package:flutter/material.dart';
import '../common/colo_extension.dart';
import '../helpers/workout_parser.dart';
import '../models/Workout/workout.dart';
import '../view/Workout/trainingSession.dart';
import 'package:permission_handler/permission_handler.dart';

class SessionSliderCard extends StatelessWidget {
  final Workout workout;
  final FtmsController ftmsController;

  const SessionSliderCard({
    super.key,
    required this.workout,
    required this.ftmsController,
  });

  Future<void> _showBluetoothPermissionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bluetooth Permission Required"),
        content: const Text(
            "To start your workout, the app needs permission to access Bluetooth. Do you want to continue?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              final granted = await _requestBluetoothPermissions(context);
              if (granted) {
                _showBluetoothPopup(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bluetooth permissions are required to start a workout."),
                  ),
                );
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  Future<bool> _requestBluetoothPermissions(BuildContext context) async {
    final statuses = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  void _showBluetoothPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BluetoothPopupDialog(
        onConnected: (trainerId) {
          Navigator.pop(context); // Close popup
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
        onPressed: () => _showBluetoothPermissionDialog(context),
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
