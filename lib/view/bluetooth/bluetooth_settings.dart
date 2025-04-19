import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothPopupDialog extends StatefulWidget {
  final Function(String trainerId)? onConnected;

  const BluetoothPopupDialog({super.key, this.onConnected});

  @override
  State<BluetoothPopupDialog> createState() => _BluetoothPopupDialogState();
}

class _BluetoothPopupDialogState extends State<BluetoothPopupDialog> {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final FtmsController ftmsController = FtmsController();

  List<DiscoveredDevice> smartTrainers = [];
  List<DiscoveredDevice> heartRateMonitors = [];

  bool isScanning = false;
  String? connectedTrainerId;

  @override
  void initState() {
    super.initState();
  }

  void _startScan() {
    setState(() {
      smartTrainers.clear();
      heartRateMonitors.clear();
      isScanning = true;
    });

    _ble.scanForDevices(withServices: []).listen((device) {
      if (device.name.toLowerCase().contains("trainer")) {
        if (!smartTrainers.any((d) => d.id == device.id)) {
          setState(() => smartTrainers.add(device));
        }
      } else if (device.name.toLowerCase().contains("heart") || device.name.toLowerCase().contains("hr")) {
        if (!heartRateMonitors.any((d) => d.id == device.id)) {
          setState(() => heartRateMonitors.add(device));
        }
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      setState(() => isScanning = false);
    });
  }

  void _connectTrainer(DiscoveredDevice device) async {
    await ftmsController.connectToTrainer(device.id);
    setState(() => connectedTrainerId = device.id);

    _showMetricsConfirmation(device.name);
  }

  void _showMetricsConfirmation(String deviceName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1D2939),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Connected!", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("✅ Connected to $deviceName", style: TextStyle(color: Colors.lightBlueAccent)),
              const SizedBox(height: 12),
              const Text("📊 Metrics that will be captured:", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              const Text("• Power (Watts)\n• Cadence (RPM)\n• Heart Rate (bpm)\n• Elapsed Time",
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1D2939),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Connect Devices", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("You need to connect at least one smart trainer to start your workout.", style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Available Devices", style: TextStyle(color: Colors.white)),
                ElevatedButton.icon(
                  onPressed: _startScan,
                  icon: const Icon(Icons.bluetooth_searching, size: 16),
                  label: const Text("Scan"),
                ),
              ],
            ),

            const SizedBox(height: 10),
            if (isScanning)
              const CircularProgressIndicator()
            else if (smartTrainers.isEmpty && heartRateMonitors.isEmpty)
              const Text("No devices found. Tap Scan to search.", style: TextStyle(color: Colors.white38)),

            const SizedBox(height: 10),
            ...smartTrainers.map((d) => _deviceTile(d, "Smart Trainer", isMandatory: true)),
            ...heartRateMonitors.map((d) => _deviceTile(d, "Heart Rate Monitor")),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: connectedTrainerId != null ? () {
                    Navigator.pop(context);
                    widget.onConnected?.call(connectedTrainerId!);
                  } : null,
                  child: const Text("Continue"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceTile(DiscoveredDevice device, String label, {bool isMandatory = false}) {
    final alreadyConnected = device.id == connectedTrainerId;
    return ListTile(
      leading: Icon(Icons.bluetooth, color: alreadyConnected ? Colors.green : Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      subtitle: Text(device.name, style: const TextStyle(color: Colors.white70)),
      trailing: ElevatedButton(
        onPressed: alreadyConnected ? null : () => _connectTrainer(device),
        child: Text(alreadyConnected ? "Connected" : "Connect"),
      ),
    );
  }
}
