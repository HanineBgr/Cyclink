// lib/view/Workout/WorkoutLibrary.dart
import 'dart:math' as math;
import 'package:fast_rhino/common_widget/search_bar.dart';
import 'package:fast_rhino/common_widget/workoutButton.dart';
import 'package:fast_rhino/common_widget/step_detail_row.dart';
import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/helpers/workout_parser.dart';
import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:fast_rhino/providers/workout_provider.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:fast_rhino/view/Workout/workoutDetail.dart';
import 'package:fast_rhino/view/Workout/workoutList.dart';
import 'package:flutter/material.dart';
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

class _WorkoutLibraryState extends State<WorkoutLibrary> {
  TextEditingController txtSearch = TextEditingController();
  final FtmsController ftmsController = FtmsController();
  Workout? selectedWorkout;
  List<Map<String, String>> essentialSteps = [];
  List<WorkoutInterval> intervals = [];
  final ScrollController _scrollController = ScrollController();
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutProvider>(context, listen: false)
        .fetchWorkouts()
        .then((_) => _restoreWorkout());
    Provider.of<AuthProvider>(context, listen: false).fetchUser();
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
      final provider =
          Provider.of<WorkoutProvider>(context, listen: false);
      final match = provider.workouts.firstWhere(
        (w) => w.id == id,
        orElse: () => Workout(
          id: '',
          name: '',
          description: '',
          durationMinutes: 0,
          tss: 0,
          category: '',
          xml: '',
        ),
      );
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
    final doc = XmlDocument.parse(xml);
    final workoutNode = doc.findAllElements("workout").first;
    final summary = <String, List<String>>{
      "Warmup": [],
      "Intervals": [],
      "Recovery": [],
      "Cooldown": [],
    };

    for (var e in workoutNode.children.whereType<XmlElement>()) {
      final tag = e.name.local;
      final dur = int.tryParse(e.getAttribute("Duration") ?? "0") ?? 0;
      if (tag == "Warmup" || tag == "Cooldown") {
        final low =
            (double.tryParse(e.getAttribute("PowerLow") ?? "0") ?? 0) * 100;
        final high =
            (double.tryParse(e.getAttribute("PowerHigh") ?? "0") ?? 0) * 100;
        final range = tag == "Warmup"
            ? "${_formatTime(dur)} from ${low.toInt()}% to ${high.toInt()}% FTP"
            : "${_formatTime(dur)} from ${high.toInt()}% to ${low.toInt()}% FTP";
        summary[tag]!.add("$range, cadence: free");
      } else if (tag == "SteadyState") {
        final power =
            (double.tryParse(e.getAttribute("Power") ?? "0") ?? 0) * 100;
        final detail = "${_formatTime(dur)} at ${power.toInt()}% FTP" +
            (power >= 105 ? ", cadence: 95+ rpm" : ", cadence: free");
        (power >= 105 ? summary["Intervals"]! : summary["Recovery"]!)
            .add(detail);
      } else if (tag == "IntervalsT") {
        final repeat = int.tryParse(e.getAttribute("Repeat") ?? "1") ?? 1;
        final onDur = int.tryParse(e.getAttribute("OnDuration") ?? "0") ?? 0;
        final offDur =
            int.tryParse(e.getAttribute("OffDuration") ?? "0") ?? 0;
        final onPow =
            (double.tryParse(e.getAttribute("OnPower") ?? "0") ?? 0) * 100;
        final offPow =
            (double.tryParse(e.getAttribute("OffPower") ?? "0") ?? 0) * 100;
        summary["Intervals"]!.add(
          "$repeat × (${_formatTime(onDur)} at ${onPow.toInt()}% / ${_formatTime(offDur)} at ${offPow.toInt()}%)",
        );
      }
    }

    setState(() {
      essentialSteps = [
        if (summary["Warmup"]!.isNotEmpty)
          {"title": "Warmup", "detail": summary["Warmup"]!.first},
        if (summary["Intervals"]!.isNotEmpty)
          {"title": "Intervals", "detail": summary["Intervals"]!.join("\n")},
        if (summary["Recovery"]!.isNotEmpty)
          {"title": "Recovery", "detail": summary["Recovery"]!.join("\n")},
        if (summary["Cooldown"]!.isNotEmpty)
          {"title": "Cooldown", "detail": summary["Cooldown"]!.first},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workouts = workoutProvider.workouts;
    final authProvider = Provider.of<AuthProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (selectedWorkout != null) {
          setState(() {
            selectedWorkout = null;
            essentialSteps.clear();
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(_lastScrollOffset);
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
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
                    final prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString(
                        'selectedWorkoutId', selectedWorkout!.id);
                    setState(() {
                      selectedWorkout = null;
                      essentialSteps.clear();
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.jumpTo(_lastScrollOffset);
                    });
                  },
                )
              : null,
          title: Text(
            selectedWorkout == null
                ? "Workout Library"
                : selectedWorkout!.name,
            style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.bold),
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
                    child: selectedWorkout == null
                        // ← NOW this is *directly* your scrollable list
                        ? WorkoutListView(
                            workouts: workouts,
                            onSelect: (w) async {
                              _lastScrollOffset =
                                  _scrollController.offset;
                              await _saveLastScreen(w.id);
                              setState(() {
                                selectedWorkout = w;
                                intervals =
                                    parseWorkoutXml(w.xml);
                                _parseEssentialSteps(w.xml);
                              });
                            },
                            scrollController: _scrollController,
                          )
                        // ← detail view unchanged
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: WorkoutDetailView(
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
      ),
    );
  }
}
