import 'dart:typed_data';

class FtmsData {
  final double instantaneousSpeed; // km/h
  final int instantaneousCadence; // RPM
  final int instantaneousPower; // Watts
  final int heartRate; // BPM (optional)
  final double totalDistance; // meters

  FtmsData({
    required this.instantaneousSpeed,
    required this.instantaneousCadence,
    required this.instantaneousPower,
    required this.heartRate,
    required this.totalDistance,
  });

  /// Parses a BLE FTMS notification byte array
  factory FtmsData.fromFTMS(List<int> value) {
    final data = Uint8List.fromList(value);
    final buffer = ByteData.sublistView(data);

    int index = 0;

    // FTMS flags (2 bytes) - can be used if needed
    final int flags = buffer.getUint16(index, Endian.little);
    index += 2;

    // Instantaneous Speed (2 bytes) -> unit: 1/100 km/h
    final int rawSpeed = buffer.getUint16(index, Endian.little);
    final double speed = rawSpeed / 100.0;
    index += 2;

    // Instantaneous Cadence (2 bytes) -> RPM
    final int cadence = buffer.getUint16(index, Endian.little);
    index += 2;

    // Instantaneous Power (2 bytes) -> Watts
    final int power = buffer.getInt16(index, Endian.little);
    index += 2;

    // Optional: Heart rate (1 byte) -> BPM
    int heartRate = 0;
    if (index < data.length) {
      heartRate = buffer.getUint8(index);
      index += 1;
    }

    // Optional: Total distance (3 bytes) -> meters
    double totalDistance = 0;
    if (index + 3 <= data.length) {
      final int distLow = buffer.getUint8(index);
      final int distMid = buffer.getUint8(index + 1);
      final int distHigh = buffer.getUint8(index + 2);
      totalDistance = (distHigh << 16 | distMid << 8 | distLow) * 1.0;
    }

    return FtmsData(
      instantaneousSpeed: speed,
      instantaneousCadence: cadence,
      instantaneousPower: power,
      heartRate: heartRate,
      totalDistance: totalDistance,
    );
  }

  @override
  String toString() {
    return '''
    Speed: ${instantaneousSpeed.toStringAsFixed(2)} km/h,
    Cadence: $instantaneousCadence RPM,
    Power: $instantaneousPower W,
    Heart Rate: $heartRate BPM,
    Distance: ${totalDistance.toStringAsFixed(1)} m
    ''';
  }
}
