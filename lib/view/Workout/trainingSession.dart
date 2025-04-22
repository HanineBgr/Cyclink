import 'dart:async';
import 'dart:math' as math;
import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveSessionScreen extends StatefulWidget {
  final List<WorkoutInterval> intervals;
  final FtmsController ftmsController;

  const LiveSessionScreen({super.key, required this.intervals, required this.ftmsController});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  int elapsedSeconds = 0;
  double targetPower = 0;
  int currentPower = 0;
  int heartRate = 0;
  int cadence = 0;
  int currentIntervalIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    widget.ftmsController.onPowerReceived = (val) => setState(() => currentPower = val);
    widget.ftmsController.onHeartRateReceived = (val) => setState(() => heartRate = val);
    widget.ftmsController.onCadenceReceived = (val) => setState(() => cadence = val);
    startSession();
  }

  void startSession() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsedSeconds++;
        double cumulative = 0;
        for (int i = 0; i < widget.intervals.length; i++) {
          cumulative += widget.intervals[i].duration * 60;
          if (elapsedSeconds <= cumulative) {
            currentIntervalIndex = i;
            targetPower = widget.intervals[i].power;
            break;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.ftmsController.dispose();
    super.dispose();
  }

  Widget _buildTile(String label, String value, String sub) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Text(label.toUpperCase(), style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            if (sub.isNotEmpty)
              Text(sub, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutChart() {
    final intervals = widget.intervals;
    final maxPower = intervals.map((e) => e.power).reduce(math.max);

    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: intervals.map((interval) {
          final heightFactor = interval.power / maxPower;
          final width = interval.duration * 6; 
          final color = Colors.orangeAccent;
          return Container(
            width: width,
            height: 100 * heightFactor,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = widget.intervals.fold<double>(0, (sum, i) => sum + i.duration * 60);
    final remaining = totalDuration - elapsedSeconds;

    return Scaffold(
      backgroundColor: const Color(0xFF101828),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("Live Workout",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              _buildWorkoutChart(),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: elapsedSeconds / totalDuration,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
              const SizedBox(height: 20),
              Row(children: [
                _buildTile("TARGET", "${targetPower.toInt()} W", "Zone"),
                _buildTile("POWER", "$currentPower W", ""),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _buildTile("HEART RATE", "$heartRate bpm", ""),
                _buildTile("CADENCE", "$cadence rpm", ""),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _buildTile("SPEED", "${(cadence * 0.5).toStringAsFixed(1)} km/h", ""),
              ]),
              const Spacer(),
              Text("Elapsed Time",
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
              Text("${(elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(elapsedSeconds % 60).toString().padLeft(2, '0')}",
                  style: GoogleFonts.poppins(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("End Session"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}