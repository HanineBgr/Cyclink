import 'dart:math' as math;
import 'package:fast_rhino/common_widget/search_bar.dart';
import 'package:fast_rhino/common_widget/slider_card.dart';
import 'package:fast_rhino/common_widget/step_detail_row.dart';
import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/helpers/workout_parser.dart';
import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:fast_rhino/providers/workout_provider.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:fast_rhino/view/Workout/workoutDetail.dart';
import 'package:fast_rhino/view/Workout/workoutList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_rhino/common_widget/workout_card.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:readmore/readmore.dart';
import 'package:xml/xml.dart';
import 'package:fast_rhino/providers/auth_provider.dart';
import '../../common/colo_extension.dart';

class WorkoutLibrary extends StatefulWidget {
  final Map eObj;
  const WorkoutLibrary({super.key, required this.eObj});
  @override
  State<WorkoutLibrary> createState() => _WorkoutLibraryState();
}

class _WorkoutLibraryState extends State<WorkoutLibrary> with WidgetsBindingObserver {
  TextEditingController txtSearch = TextEditingController();
  final FtmsController ftmsController = FtmsController();
  Workout? selectedWorkout;
  List<Map<String, String>> essentialSteps = [];
  List<WorkoutInterval> intervals = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<WorkoutProvider>(context, listen: false).fetchWorkouts().then((_) {
      _restoreWorkout();
    });
    Provider.of<AuthProvider>(context, listen: false).fetchUser();
    _listenToBackButton();
  }

  void _listenToBackButton() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        _restoreWorkout();
      }
      return null;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _restoreWorkout();
    }
  }

  Future<void> _saveLastScreen(String workoutId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'WorkoutLibrary');
    await prefs.setString('selectedWorkoutId', workoutId);
  }

  Future<void> _restoreWorkout() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('selectedWorkoutId');
    if (id != null) {
      final provider = Provider.of<WorkoutProvider>(context, listen: false);
      final match = provider.workouts.firstWhere((w) => w.id == id, orElse: () => Workout(id: '', name: '', description: '', durationMinutes: 0, tss: 0, category: '', xml: ''));
      if (match.id.isNotEmpty) {
        setState(() {
          selectedWorkout = match;
          intervals = parseWorkoutXml(match.xml);
          _parseEssentialSteps(match.xml);
        });
      }
    }
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _parseEssentialSteps(String xml) {
    final document = XmlDocument.parse(xml);
    final workoutNode = document.findAllElements("workout").first;
    final Map<String, List<String>> summary = {
      "Warmup": [],
      "Intervals": [],
      "Recovery": [],
      "Cooldown": [],
    };
    for (var element in workoutNode.children.whereType<XmlElement>()) {
      final tag = element.name.local;
      final duration = int.tryParse(element.getAttribute("Duration") ?? "0") ?? 0;
      if (tag == "Warmup" || tag == "Cooldown") {
        final low = (double.tryParse(element.getAttribute("PowerLow") ?? "0") ?? 0) * 100;
        final high = (double.tryParse(element.getAttribute("PowerHigh") ?? "0") ?? 0) * 100;
        final range = tag == "Warmup"
            ? "${_formatTime(duration)} from ${low.toInt()}% to ${high.toInt()}% FTP"
            : "${_formatTime(duration)} from ${high.toInt()}% to ${low.toInt()}% FTP";
        summary[tag]!.add("$range, cadence: free");
      } else if (tag == "SteadyState") {
        final power = (double.tryParse(element.getAttribute("Power") ?? "0") ?? 0) * 100;
        final detail = "${_formatTime(duration)} at ${power.toInt()}% FTP" +
            (power >= 105 ? ", cadence: 95+ rpm" : ", cadence: free");
        (power >= 105 ? summary["Intervals"] : summary["Recovery"])!.add(detail);
      } else if (tag == "IntervalsT") {
        final repeat = int.tryParse(element.getAttribute("Repeat") ?? "1") ?? 1;
        final onDuration = int.tryParse(element.getAttribute("OnDuration") ?? "0") ?? 0;
        final offDuration = int.tryParse(element.getAttribute("OffDuration") ?? "0") ?? 0;
        final onPower = (double.tryParse(element.getAttribute("OnPower") ?? "0") ?? 0) * 100;
        final offPower = (double.tryParse(element.getAttribute("OffPower") ?? "0") ?? 0) * 100;
        summary["Intervals"]!.add("$repeat × (${_formatTime(onDuration)} at ${onPower.toInt()}% / ${_formatTime(offDuration)} at ${offPower.toInt()}%)");
      }
    }
    setState(() {
      essentialSteps = [
        if (summary["Warmup"]!.isNotEmpty) {"title": "Warmup", "detail": summary["Warmup"]!.first},
        if (summary["Intervals"]!.isNotEmpty) {"title": "Intervals", "detail": summary["Intervals"]!.join("\n")},
        if (summary["Recovery"]!.isNotEmpty) {"title": "Recovery", "detail": summary["Recovery"]!.join("\n")},
        if (summary["Cooldown"]!.isNotEmpty) {"title": "Cooldown", "detail": summary["Cooldown"]!.first},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workouts = workoutProvider.workouts;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: selectedWorkout != null
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: TColor.black),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selectedWorkoutId', selectedWorkout!.id);
                  setState(() {
                    selectedWorkout = null;
                    essentialSteps.clear();
                  });
                },
              )
            : null,
        title: Text(
          selectedWorkout == null ? "Workout Library" : selectedWorkout!.name,
          style: TextStyle(color: TColor.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: authProvider.ftp == 0
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (selectedWorkout == null)
                  WorkoutSearchBar(
                    controller: txtSearch,
                    workoutProvider: workoutProvider,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: selectedWorkout == null
                        ? WorkoutListView(
                            workouts: workouts,
                            onSelect: (workout) async {
                              await _saveLastScreen(workout.id);
                              setState(() {
                                selectedWorkout = workout;
                                intervals = parseWorkoutXml(workout.xml);
                                _parseEssentialSteps(workout.xml);
                              });
                            },
                          )
                        : WorkoutDetailView(
                            workout: selectedWorkout!,
                            intervals: intervals,
                            essentialSteps: essentialSteps,
                            ftp: authProvider.ftp.toDouble(),
                            ftmsController: ftmsController,
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}
