import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fast_rhino/view/bluetooth/bluetooth_settings.dart';

Future<void> requestBluetoothPermissions() async {
  final statuses = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
    Permission.locationWhenInUse,
  ].request();

  if (statuses.values.any((status) => !status.isGranted)) {
    print("Some permissions denied");
  }
}

Future<void> showSystemLevelBluetoothFlow(BuildContext context, Function(String trainerId) onConnected) async {
  await requestBluetoothPermissions();

  // If all permissions are granted, show the actual scan/connect popup
  final allGranted = await Future.wait([
    Permission.bluetoothScan.status,
    Permission.bluetoothConnect.status,
    Permission.bluetoothAdvertise.status,
    Permission.locationWhenInUse.status,
  ]);

  if (allGranted.every((status) => status.isGranted)) {
    showDialog(
      context: context,
      builder: (_) => BluetoothPopupDialog(onConnected: onConnected),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bluetooth permissions are required.")),
    );
  }
} 

/// Use this call inside your button:
/// 
/// ElevatedButton(
///   onPressed: () => showSystemLevelBluetoothFlow(context, (trainerId) {
///     // Proceed to next screen or logic
///   }),
///   child: Text("Connect Trainer"),
/// )
