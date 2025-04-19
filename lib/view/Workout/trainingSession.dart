import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:fast_rhino/common/colo_extension.dart';

class LiveSessionScreen extends StatefulWidget {
  final Workout workout;
  final FtmsController ftmsController;

  const LiveSessionScreen({
    super.key,
    required this.workout,
    required this.ftmsController,
  });

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  int targetPower = 100;
  int currentPower = 0;
  int heartRate = 0;
  int cadence = 0;
  double speed = 0.0;
  int intervalIndex = 1;
  Duration elapsed = Duration.zero;
  Duration totalDuration = Duration(minutes: 45);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.ftmsController.onPowerReceived = (val) {
      setState(() => currentPower = val);
    };
    widget.ftmsController.onCadenceReceived = (val) {
      setState(() => cadence = val);
    };
    widget.ftmsController.onHeartRateReceived = (val) {
      setState(() => heartRate = val);
    };

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsed += const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.ftmsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = totalDuration - elapsed;
    return Scaffold(
      backgroundColor: const Color(0xFF111B2E),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      const Spacer(),
                      Text(widget.workout.name,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Icon(Icons.close, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.workout.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              childAspectRatio: 1.7,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTile("TARGET", "$targetPower W", "40%"),
                _buildTile("POWER", "$currentPower W", ""),
                _buildTile("HEART RATE", "$heartRate", "ZONE Z1"),
                _buildTile("TARGET", "85 rpm", "rpm"),
                _buildTile("CADENCE", "$cadence rpm", ""),
                _buildTile("SPEED", "${speed.toStringAsFixed(1)}", "AVG 7.7 km/h"),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoText("INTERVAL", "$intervalIndex/11"),
                _infoText("REMAINING", _formatDuration(remaining)),
                _infoText("ELAPSED", _formatDuration(elapsed)),
                _infoText("TOTAL", _formatDuration(totalDuration)),
              ],
            ),

            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: elapsed.inSeconds / totalDuration.inSeconds,
              minHeight: 6,
              color: Colors.lightBlueAccent,
              backgroundColor: Colors.grey[800],
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              //child: LiveWorkoutGraph(), // create this widget to mimic the bar chart
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomButton("ERG", Colors.indigo),
                  _bottomButton("INTENSITY\n100%", Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, String value, String sub) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(sub, style: const TextStyle(color: Colors.lightBlue, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _infoText(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _bottomButton(String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  String _formatDuration(Duration d) => d.toString().split('.').first.padLeft(5, "0");
}
