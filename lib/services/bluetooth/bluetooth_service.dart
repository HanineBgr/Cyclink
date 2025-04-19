import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class FtmsController {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late DiscoveredDevice connectedDevice;
  late QualifiedCharacteristic powerMeasurementChar;

  StreamSubscription<List<int>>? _powerSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  Function(int power)? onPowerReceived;
  Function(int cadence)? onCadenceReceived;
  Function(int hr)? onHeartRateReceived;

  Future<void> connectToTrainer(String deviceId) async {
    _connectionSubscription = _ble.connectToDevice(id: deviceId).listen(
      (connectionState) {
        if (connectionState.connectionState == DeviceConnectionState.connected) {
          print('✅ Connected to FTMS trainer: $deviceId');

          final characteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("1826"), // Fitness Machine Service
            characteristicId: Uuid.parse("2AD2"), // Indoor Bike Data
            deviceId: deviceId,
          );

          powerMeasurementChar = characteristic;

          _powerSubscription = _ble
              .subscribeToCharacteristic(characteristic)
              .listen((data) => _parseIndoorBikeData(data));
        } else if (connectionState.connectionState == DeviceConnectionState.disconnected) {
          print('⚠️ Disconnected from trainer.');
        }
      },
      onError: (e) => print('❌ Connection error: $e'),
    );
  }

  void _parseIndoorBikeData(List<int> data) {
    if (data.length < 8) return;

    final flags = data[0];
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
  }
}
