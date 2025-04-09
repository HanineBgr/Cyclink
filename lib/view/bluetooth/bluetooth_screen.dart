import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:math' as math;

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen>
    with SingleTickerProviderStateMixin {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? connectedDevice;
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  bool isConnected = false;
  late AnimationController _controller;

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
    super.dispose();
  }

  void scanAndConnect() async {
    setState(() {
      isScanning = true;
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results) async {
      setState(() {
        scanResults = results;
      });

      if (results.isNotEmpty) {
        final device = results.first.device;
        await connectToDevice(device);
        FlutterBluePlus.stopScan();
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
        isConnected = true;
        isScanning = false;
      });

      discoverServices(device);
      showSuccessDialog();
    } catch (e) {
      print("Connection failed: $e");
    }
  }

  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("1826")) {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            print("FTMS Data Received: $value");
          });
        }
      }
    }
  }

  void showSuccessDialog() {
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                ),
              ],
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
                Text(
                  'Awesome!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bluetooth device connected successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB8E0FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog
                  },
                  child: Text('Go to Profile'),
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  Text(
                    "Connexion bluetooth",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.more_horiz, size: 20),
                ],
              ),
              const SizedBox(height: 32),

              // Sub text
              Text(
                "Please stay close to your home trainer for a smooth connection.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 48),

              // Loading animation
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
                )
              else
                SizedBox(height: 220),

              Spacer(),

              // Gradient Button
              GestureDetector(
                onTap: () {
                  scanAndConnect();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF80D0FF),
                        Color(0xFF7285FF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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

// Custom ripple animation painter
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
