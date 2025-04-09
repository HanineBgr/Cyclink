import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEService {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? ftmsCharacteristic;

  // UUID du service FTMS (Fitness Machine Service)
  static const String ftmsServiceUUID = "00001826-0000-1000-8000-00805f9b34fb";

  // UUID de la caractéristique "Fitness Machine Measurement"
  static const String ftmsCharacteristicUUID = "00002acc-0000-1000-8000-00805f9b34fb";

  // Scanner les périphériques BLE
  Stream<List<ScanResult>> scanDevices() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    return FlutterBluePlus.scanResults;
  }

  // Se connecter à un périphérique BLE
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    connectedDevice = device;
    print('Connecté à ${device.name}');
    await discoverServices();
  }

  // Découvrir les services du périphérique connecté
  Future<void> discoverServices() async {
    if (connectedDevice == null) return;

    List<BluetoothService> services = await connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid.toString() == ftmsServiceUUID) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == ftmsCharacteristicUUID) {
            ftmsCharacteristic = characteristic;
            listenToFTMSData();
            break;
          }
        }
      }
    }
  }

  // Lire et écouter les données FTMS
  void listenToFTMSData() {
    if (ftmsCharacteristic != null) {
      ftmsCharacteristic!.setNotifyValue(true);
      ftmsCharacteristic!.value.listen((value) {
        print('Données FTMS reçues : $value');
        // Ajouter ici le parsing des données si nécessaire
      });
    }
  }
}
