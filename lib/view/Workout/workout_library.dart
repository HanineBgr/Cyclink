import 'package:fast_rhino/common_widget/slider_card.dart';
import 'package:fast_rhino/common_widget/step_detail_row.dart';
import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/helpers/workout_parser.dart';
import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:fast_rhino/providers/workout_provider.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_rhino/common_widget/workout_card.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:readmore/readmore.dart';
import 'package:xml/xml.dart';
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

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutProvider>(context, listen: false).fetchWorkouts();
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

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: BackButton(color: TColor.black),
        title: Text("Workout Library", style: TextStyle(color: TColor.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          if (selectedWorkout == null) _buildSearchBar(workoutProvider),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: selectedWorkout == null ? _buildWorkoutList(workouts) : _buildWorkoutDetail(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WorkoutProvider workoutProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: txtSearch,
                onSubmitted: (value) {
                  final searchText = value.trim();
                  if (searchText.isNotEmpty) {
                    workoutProvider.searchWorkoutsByName(searchText);
                  } else {
                    workoutProvider.fetchWorkouts();
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search Workout",
                  border: InputBorder.none,
                  prefixIcon: GestureDetector(
                    onTap: () {
                      final searchText = txtSearch.text.trim();
                      if (searchText.isNotEmpty) {
                        workoutProvider.searchWorkoutsByName(searchText);
                      } else {
                        workoutProvider.fetchWorkouts();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset("assets/img/search.png", width: 25, height: 25),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 1,
              height: 25,
              color: TColor.gray.withOpacity(0.3),
            ),
            InkWell(
              onTap: () {},
              child: Image.asset("assets/img/Filter.png", width: 25, height: 25),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutList(List<Workout> workouts) {
    return Column(
      children: workouts.map((workout) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedWorkout = workout;
              intervals = parseWorkoutXml(workout.xml);
              _parseEssentialSteps(workout.xml);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: WorkoutCard(workout: workout),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkoutDetail(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(selectedWorkout!.name,
            style: TextStyle(color: TColor.black, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ReadMoreText(
          textAlign: TextAlign.justify,
          selectedWorkout!.description,
          colorClickableText: TColor.primaryColor1,
          style: TextStyle(
            
            color: TColor.gray, fontSize: 14),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMetricTile("Duration", "${selectedWorkout!.durationMinutes} min", Icons.timer),
            const SizedBox(width: 40),
            _buildMetricTile("TSS", selectedWorkout!.tss.toString(), Icons.bolt),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Workout Structure",
                style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
            Text("${essentialSteps.length} Steps", style: TextStyle(color: TColor.gray, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        ...essentialSteps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return StepDetailRow(
            sObj: {
              "no": "${index + 1}".padLeft(2, "0"),
              "title": step["title"]!,
              "detail": step["detail"]!,
            },
            isLast: index == essentialSteps.length - 1,
          );
        }).toList(),
        const SizedBox(height: 25),
        Text("Power Graph",
            style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        WorkoutGraphBar(intervals: intervals),
        const SizedBox(height: 20),
        SessionSliderCard(workout: selectedWorkout!, ftmsController: ftmsController),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: TColor.primaryColor1),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TColor.black)),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
