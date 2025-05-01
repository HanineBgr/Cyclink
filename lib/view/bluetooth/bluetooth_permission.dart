import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bluetooth_settings.dart';

Future<void> showSystemLevelBluetoothFlow(BuildContext context, Function(String trainerId) onConnected) async {
  final statuses = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
  ].request();

  if (statuses.values.every((status) => status.isGranted)) {
    showDialog(
      context: context,
      builder: (_) => BluetoothPopupDialog(onConnected: onConnected),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bluetooth permissions are required to connect.")),
    );
  }
}

