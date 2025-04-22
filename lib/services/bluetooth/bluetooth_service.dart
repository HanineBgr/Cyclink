import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class FtmsController {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  StreamSubscription<List<int>>? _powerSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  Function(int power)? onPowerReceived;
  Function(int cadence)? onCadenceReceived;
  Function(int hr)? onHeartRateReceived;

  final Map<String, List<DiscoveredDevice>> categorizedDevices = {
    'controllable': [],
    'power_meter': [],
    'speed_cadence': [],
    'hrm': [],
    'moxy': [],
  };

  /// Standard BLE service UUIDs
  static const controllableService = "1826"; // FTMS
  static const powerMeterService = "1818"; // Cycling Power
  static const speedCadenceService = "1816"; // Cycling Speed & Cadence
  static const hrService = "180D"; // Heart Rate
  static const moxyService = "FE00"; // Custom example (used by MOXY)

  void startSmartScan({required void Function(Map<String, List<DiscoveredDevice>>) onUpdate}) {
    categorizedDevices.forEach((key, _) => categorizedDevices[key] = []);

    _scanSubscription = _ble.scanForDevices(withServices: []).listen((device) {
      final services = device.serviceUuids.map((uuid) => uuid.toString().toLowerCase()).toList();
      final name = device.name.toLowerCase();

      if (services.contains(controllableService) || name.contains("trainer")) {
        _addDevice("controllable", device);
      } else if (services.contains(powerMeterService) || name.contains("power")) {
        _addDevice("power_meter", device);
      } else if (services.contains(speedCadenceService) || name.contains("cadence") || name.contains("speed")) {
        _addDevice("speed_cadence", device);
      } else if (services.contains(hrService) || name.contains("hr") || name.contains("heart")) {
        _addDevice("hrm", device);
      } else if (services.contains(moxyService) || name.contains("moxy")) {
        _addDevice("moxy", device);
      }

      onUpdate(categorizedDevices);
    });

    // Auto stop after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      _scanSubscription?.cancel();
    });
  }

  void _addDevice(String category, DiscoveredDevice device) {
    if (!categorizedDevices[category]!.any((d) => d.id == device.id)) {
      categorizedDevices[category]!.add(device);
    }
  }

  Future<void> connectToTrainer(String deviceId) async {
    _connectionSubscription = _ble.connectToDevice(id: deviceId).listen(
      (connectionState) {
        if (connectionState.connectionState == DeviceConnectionState.connected) {
          final characteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("1826"),
            characteristicId: Uuid.parse("2AD2"),
            deviceId: deviceId,
          );

          _powerSubscription = _ble
              .subscribeToCharacteristic(characteristic)
              .listen((data) => _parseIndoorBikeData(data));
        }
      },
      onError: (e) => print("Connection error: $e"),
    );
  }

  void _parseIndoorBikeData(List<int> data) {
    if (data.length < 8) return;

    final power = data[2] | (data[3] << 8);
    final cadence = data[4] | (data[5] << 8);
    final hr = data[6];

    onPowerReceived?.call(power);
    onCadenceReceived?.call(cadence);
    onHeartRateReceived?.call(hr);
  }

  void dispose() {
    _powerSubscription?.cancel();
    _connectionSubscription?.cancel();
    _scanSubscription?.cancel();
  }
}
