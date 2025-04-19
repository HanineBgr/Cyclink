import 'dart:math' as math;
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../common/colo_extension.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen>
    with SingleTickerProviderStateMixin {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  final FtmsController ftmsController = FtmsController();

  late AnimationController _controller;
  List<DiscoveredDevice> devices = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    ftmsController.dispose();
    super.dispose();
  }

  void startScan() async {
    setState(() {
      isScanning = true;
      devices.clear();
    });

    _ble.scanForDevices(withServices: []).listen((device) {
      if (!devices.any((d) => d.id == device.id)) {
        setState(() {
          devices.add(device);
        });
      }
    });

    await Future.delayed(Duration(seconds: 10));
    setState(() {
      isScanning = false;
    });
  }

  void connectToDevice(DiscoveredDevice device) async {
    try {
      await ftmsController.connectToTrainer(device.id);
      showSuccessDialog(device.name);
    } catch (e) {
      print("Connection failed: $e");
    }
  }

  void showSuccessDialog(String deviceName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFB8E0FF),
                  child: Icon(Icons.check, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text('Connected!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent)),
                const SizedBox(height: 8),
                Text('Connected to $deviceName',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB8E0FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Continue'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  Text("Bluetooth Connection",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black)),
                  Icon(Icons.more_horiz, size: 20),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                "Make sure your FTMS simulator is nearby and not already connected.",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
              const SizedBox(height: 32),
              if (isScanning)
                SizedBox(
                  height: 220,
                  width: 220,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, child) {
                      return CustomPaint(
                        painter: RipplePainter(_controller.value),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (_, index) {
                    final device = devices[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                            device.name.isNotEmpty
                                ? device.name
                                : 'Unnamed device'),
                        subtitle: Text(device.id),
                        trailing: ElevatedButton(
                          child: Text('Connect'),
                          onPressed: () => connectToDevice(device),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: startScan,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF80D0FF), Color(0xFF7285FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isScanning ? 'Scanning...' : 'Scan',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double animationValue;
  RipplePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFFB8AFFF).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final progress = (animationValue + i * 0.2) % 1.0;
      final radius = maxRadius * progress;
      paint.color = Color(0xFFB8AFFF).withOpacity(1.0 - progress);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi * 0.8,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}
