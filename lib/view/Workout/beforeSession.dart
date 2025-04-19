/*import 'package:fast_rhino/common_widget/workout_chart.dart';
import 'package:fast_rhino/helpers/graph_parser.dart';
import 'package:fast_rhino/models/Workout/workout.dart';
import 'package:fast_rhino/services/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:xml/xml.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/slider_card.dart';
import '../../common_widget/step_detail_row.dart';

class BeforeSessionScreen extends StatefulWidget {
  final Workout workout;
  final FtmsController ftmsController; 
  const BeforeSessionScreen({super.key, required this.workout, required this.ftmsController});

  @override
  State<BeforeSessionScreen> createState() => _BeforeSessionScreenState();
}

class _BeforeSessionScreenState extends State<BeforeSessionScreen> {
  List<Map<String, String>> essentialSteps = [];

  @override
  void initState() {
    super.initState();
    _parseEssentialSteps(widget.workout.xml);
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

      if (tag == "Warmup") {
        final duration = int.tryParse(element.getAttribute("Duration") ?? "0") ?? 0;
        final low = (double.tryParse(element.getAttribute("PowerLow") ?? "0") ?? 0) * 100;
        final high = (double.tryParse(element.getAttribute("PowerHigh") ?? "0") ?? 0) * 100;
        summary["Warmup"]!.add("${_formatTime(duration)} from ${low.toInt()}% to ${high.toInt()}% FTP, cadence: free");
      } else if (tag == "Cooldown") {
        final duration = int.tryParse(element.getAttribute("Duration") ?? "0") ?? 0;
        final low = (double.tryParse(element.getAttribute("PowerLow") ?? "0") ?? 0) * 100;
        final high = (double.tryParse(element.getAttribute("PowerHigh") ?? "0") ?? 0) * 100;
        summary["Cooldown"]!.add("${_formatTime(duration)} from ${high.toInt()}% to ${low.toInt()}% FTP, cadence: free");
      } else if (tag == "SteadyState") {
        final duration = int.tryParse(element.getAttribute("Duration") ?? "0") ?? 0;
        final power = (double.tryParse(element.getAttribute("Power") ?? "0") ?? 0) * 100;
        if (power >= 105) {
          summary["Intervals"]!.add("${_formatTime(duration)} at ${power.toInt()}% FTP, cadence: 95+ rpm");
        } else {
          summary["Recovery"]!.add("${_formatTime(duration)} at ${power.toInt()}% FTP, cadence: free");
        }
      } else if (tag == "IntervalsT") {
        final repeat = int.tryParse(element.getAttribute("Repeat") ?? "1") ?? 1;
        final onDuration = int.tryParse(element.getAttribute("OnDuration") ?? "0") ?? 0;
        final offDuration = int.tryParse(element.getAttribute("OffDuration") ?? "0") ?? 0;
        final onPower = (double.tryParse(element.getAttribute("OnPower") ?? "0") ?? 0) * 100;
        final offPower = (double.tryParse(element.getAttribute("OffPower") ?? "0") ?? 0) * 100;

        final onTime = _formatTime(onDuration);
        final offTime = _formatTime(offDuration);

        summary["Intervals"]!.add(
          "$repeat × ($onTime at ${onPower.toInt()}% FTP / $offTime at ${offPower.toInt()}% FTP), cadence: free"
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

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/img/closed_btn.png", width: 15, height: 15),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/img/more_btn.png", width: 15, height: 15),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Session Description",
                style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ReadMoreText(
              widget.workout.description,
              textAlign: TextAlign.justify,
              colorClickableText: TColor.primaryColor1,
              style: TextStyle(color: TColor.gray, fontSize: 14),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMetricTile("Duration", "${widget.workout.durationMinutes} min", Icons.timer),
                SizedBox(width: media.width * 0.2),
                _buildMetricTile("TSS", widget.workout.tss.toString(), Icons.bolt),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Workout Structure",
                    style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () {},
                  child: Text("${essentialSteps.length} Steps",
                      style: TextStyle(color: TColor.gray, fontSize: 12)),
                ),
              ],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: essentialSteps.length,
              itemBuilder: (context, index) {
                final step = essentialSteps[index];
                return StepDetailRow(
                  sObj: {
                    "no": "${index + 1}".padLeft(2, "0"),
                    "title": step["title"]!,
                    "detail": step["detail"]!,
                  },
                  isLast: index == essentialSteps.length - 1,
                );
              },
            ),
            const SizedBox(height: 25),
            Text("Power Graph",
                style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            WorkoutGraph(data: extractWorkoutGraphData(widget.workout.xml)),
            const SizedBox(height: 15),
SessionSliderCard(
  workout: widget.workout,
  ftmsController: widget.ftmsController, // <- you must have this in scope
),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: TColor.primaryColor1),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: TColor.black)),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
*/