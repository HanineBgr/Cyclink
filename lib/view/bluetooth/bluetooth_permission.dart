import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fast_rhino/view/bluetooth/bluetooth_settings.dart';

Future<void> showBluetoothPermissionDialog(BuildContext context, Function(String trainerId) onConnected) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Bluetooth Permission Required"),
        content: const Text(
            "To connect to your trainer and measure performance, we need Bluetooth permissions. Please allow to proceed."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Allow"),
            onPressed: () async {
              Navigator.pop(context); // Close permission popup

              final statuses = await [
                Permission.bluetoothScan,
                Permission.bluetoothConnect,
                Permission.bluetoothAdvertise,
                Permission.locationWhenInUse,
              ].request();

              final allGranted = statuses.values.every((status) => status.isGranted);

              if (allGranted) {
                // Now show the scan popup dialog
                showDialog(
                  context: context,
                  builder: (_) => BluetoothPopupDialog(onConnected: onConnected),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bluetooth permissions are required.")),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
