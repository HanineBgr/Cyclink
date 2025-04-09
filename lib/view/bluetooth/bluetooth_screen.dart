import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  // Scan for BLE devices
  void scanForDevices() async {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });
  }

  // Connect to a BLE device
  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });
    discoverServices(device);
  }

  // Discover services (FTMS in this case)
  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("1826")) {
          // FTMS service UUID
          characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            print("FTMS Data Received: $value");
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth FTMS Scanner')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanForDevices,
            child: Text("Scan for FTMS Devices"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final device = scanResults[index].device;
                return ListTile(
                  title: Text(device.name.isNotEmpty ? device.name : "Unknown"),
                  subtitle: Text(device.id.toString()),
                  trailing: ElevatedButton(
                    onPressed: () => connectToDevice(device),
                    child: Text("Connect"),
                  ),
                );
              },
            ),
          ),
          if (connectedDevice != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Connected to: ${connectedDevice!.name}"),
            ),
        ],
      ),
    );
  }
}
