import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../services/bluetooth/bluetooth_service.dart';

class BluetoothPopupDialog extends StatefulWidget {
  final Function(String trainerId)? onConnected;
  const BluetoothPopupDialog({super.key, this.onConnected});

  @override
  State<BluetoothPopupDialog> createState() => _BluetoothPopupDialogState();
}

class _BluetoothPopupDialogState extends State<BluetoothPopupDialog> {
  final FtmsController ftmsController = FtmsController();
  List<DiscoveredDevice> smartTrainers = [];
  List<DiscoveredDevice> heartRateMonitors = [];
  bool isScanning = false;
  String? connectedTrainerId;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    setState(() {
      isScanning = true;
      smartTrainers.clear();
      heartRateMonitors.clear();
    });

    ftmsController.startSmartScan(onUpdate: (devices) {
      setState(() {
        smartTrainers = devices['controllable'] ?? [];
        heartRateMonitors = devices['hrm'] ?? [];
        isScanning = false;
      });
    });
  }

  void _connectTrainer(DiscoveredDevice device) async {
    await ftmsController.connectToTrainer(device.id);
    setState(() => connectedTrainerId = device.id);
    widget.onConnected?.call(device.id);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    ftmsController.dispose();
    super.dispose();
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
            const Text("Connect Devices",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "You need to connect at least one smart trainer to start your workout.",
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
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
              const Text("No devices found. Tap Scan to search.",
                  style: TextStyle(color: Colors.white38)),

            const SizedBox(height: 10),

            ...smartTrainers.map((d) => _deviceTile(d, "Smart Trainer", isMandatory: true)),
            ...heartRateMonitors.map((d) => _deviceTile(d, "Heart Rate Monitor")),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
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
