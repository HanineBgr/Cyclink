import 'package:flutter/material.dart';
import 'package:fast_rhino/common_widget/workout_card.dart';
import 'package:fast_rhino/models/workout.dart';
import 'package:fast_rhino/services/zwo_parser.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/metrics_row.dart';
import '../../common_widget/power_chart.dart';
import '../../common_widget/range_slider.dart';
import '../../common_widget/round_button.dart';

class WorkoutLibrary extends StatefulWidget {
  final Map eObj;

  const WorkoutLibrary({super.key, required this.eObj});

  @override
  State<WorkoutLibrary> createState() => _WorkoutLibraryState();
}

class _WorkoutLibraryState extends State<WorkoutLibrary> {
  TextEditingController txtSearch = TextEditingController();

  final List<String> workoutFiles = [
    'assets/workouts/Foundation_Builder.zwo',
    'assets/workouts/Power_Endurance.zwo',
    // Add paths to your ZWO files
  ];
  final double ftp = 255; // Set your FTP value here

  Future<Workout> _loadWorkout(String path) async {
    return await loadWorkout(path);
  }

  Future<List<Workout>> _loadAllWorkouts() async {
    List<Workout> workouts = [];
    for (var path in workoutFiles) {
      final workout = await _loadWorkout(path);
      workouts.add(workout);
    }
    return workouts;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          widget.eObj["name"].toString(),
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: txtSearch,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        prefixIcon: Image.asset(
                          "assets/img/search.png",
                          width: 25,
                          height: 25,
                        ),
                        hintText: "Search Workout",
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
                    child: Image.asset(
                      "assets/img/Filter.png",
                      width: 25,
                      height: 25,
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: media.width * 0.05),

            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Sweet spot",
                style: TextStyle(
                    color: TColor.primaryColor1,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: media.width * 0.02),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Description",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Text(
                widget.eObj["description"] ?? "The 8 minute Functional Threshold Power (FTP) test offers an alternative means of calculating FTP.",
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),

            // === Power Chart Starts Here ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text("Power",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            PowerChart(),

            //// Metrics Section ////
            WorkoutMetricsRow(),

            SizedBox(height: media.width * 0.02),

            /// Start Button Section ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RoundButton(
                height: 25,
                title: "Start Session",
                onPressed: () {
                  // Add your start session logic
                },
              ),
            ),
            SizedBox(height: media.width * 0.05),

            CustomRangeSlider(
              title: "TSS Range: 0–200",
              min: 0,
              max: 200,
              initialValue: 100,
              labels: ["Regular", "Low", "High", "Very high"],
              activeColor: TColor.primaryColor1,
              onChanged: (value) {
                print("TSS: $value");
              },
            ),
            const SizedBox(height: 24),
            CustomRangeSlider(
              title: "Duration range 0–180 min",
              min: 0,
              max: 180,
              initialValue: 90,
              labels: ["Short", "Medium", "Long", "Epic"],
              activeColor: TColor.secondaryColor2,
              onChanged: (value) {
                print("Duration: $value");
              },
            ),

            // Load Workouts Section
            SizedBox(height: media.width * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text("Available Workouts",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),

            // Dynamic Workout Cards
            FutureBuilder<List<Workout>>(
              future: _loadAllWorkouts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No workouts available'));
                } else {
                  final workouts = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      return WorkoutCard(workout: workouts[index], );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
