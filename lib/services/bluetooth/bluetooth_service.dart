
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class FtmsController {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late QualifiedCharacteristic powerMeasurementChar;

  StreamSubscription<List<int>>? _powerSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  Function(int power)? onPowerReceived;
  Function(int cadence)? onCadenceReceived;
  Function(int hr)? onHeartRateReceived;

  final List<DiscoveredDevice> _ftmsDevices = [];

  Future<void> connectToTrainer(String deviceId) async {
    _connectionSubscription = _ble.connectToDevice(id: deviceId).listen(
      (connectionState) {
        if (connectionState.connectionState == DeviceConnectionState.connected) {
          final characteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("1826"),
            characteristicId: Uuid.parse("2AD2"),
            deviceId: deviceId,
          );

          powerMeasurementChar = characteristic;

          _powerSubscription = _ble
              .subscribeToCharacteristic(characteristic)
              .listen((data) => _parseIndoorBikeData(data));
        }
      },
      onError: (e) => print('Connection error: \$e'),
    );
  }

  void startFtmsScan({required Function(List<DiscoveredDevice>) onDevicesFound}) {
    _ftmsDevices.clear();

    _scanSubscription = _ble
        .scanForDevices(withServices: [Uuid.parse("1826")])
        .listen((device) {
      final alreadyAdded = _ftmsDevices.any((d) => d.id == device.id);
      if (!alreadyAdded) {
        _ftmsDevices.add(device);
        onDevicesFound(_ftmsDevices);
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      _scanSubscription?.cancel();
    });
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