// workout_library.dart
import 'package:fast_rhino/providers/workout_provider.dart';
import 'package:fast_rhino/view/Workout/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_rhino/common_widget/workout_card.dart';
import 'package:fast_rhino/models/workout/workout.dart';
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
  double selectedTss = 100;
  double selectedDuration = 90;

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutProvider>(context, listen: false).fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workouts = workoutProvider.workouts;

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
            // 🔍 Search Bar
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
                      onChanged: (value) {
                        final searchText = value.trim();
                        if (searchText.isEmpty) {
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .fetchWorkouts();
                        }
                      },
                      onSubmitted: (value) {
                        final searchText = value.trim();
                        if (searchText.isNotEmpty) {
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .searchWorkoutsByName(searchText);
                        } else {
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .fetchWorkouts();
                        }
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        prefixIcon: GestureDetector(
                          onTap: () {
                            final searchText = txtSearch.text.trim();
                            if (searchText.isNotEmpty) {
                              Provider.of<WorkoutProvider>(context, listen: false)
                                  .searchWorkoutsByName(searchText);
                            } else {
                              Provider.of<WorkoutProvider>(context, listen: false)
                                  .fetchWorkouts();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/img/search.png",
                              width: 25,
                              height: 25,
                            ),
                          ),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Text(
                widget.eObj["description"] ??
                    "The 8 minute Functional Threshold Power (FTP) test offers an alternative means of calculating FTP.",
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text("Power",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            PowerChart(),

            WorkoutMetricsRow(),
            SizedBox(height: media.width * 0.02),

            CustomRangeSlider(
              title: "TSS Range: 0–200",
              min: 0,
              max: 200,
              initialValue: selectedTss,
              labels: ["Regular", "Low", "High", "Very high"],
              activeColor: TColor.primaryColor1,
              onChanged: (value) {
                setState(() {
                  selectedTss = value;
                });

                Provider.of<WorkoutProvider>(context, listen: false)
                    .filterWorkouts(
                      minTss: 0,
                      maxTss: selectedTss.toInt(),
                      minDuration: 0,
                      maxDuration: selectedDuration.toInt(),
                    );
              },
            ),

            const SizedBox(height: 24),
            CustomRangeSlider(
              title: "Duration range 0–180 min",
              min: 0,
              max: 180,
              initialValue: selectedDuration,
              labels: ["Short", "Medium", "Long", "Epic"],
              activeColor: TColor.secondaryColor2,
              onChanged: (value) {
                setState(() {
                  selectedDuration = value;
                });

                Provider.of<WorkoutProvider>(context, listen: false)
                    .filterWorkouts(
                      minTss: 0,
                      maxTss: selectedTss.toInt(),
                      minDuration: 0,
                      maxDuration: selectedDuration.toInt(),
                    );
              },
            ),

            SizedBox(height: media.width * 0.02),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text("Available Workouts",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),

            if (workoutProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (workouts.isEmpty)
              const Center(child: Text("No workouts available"))
            else
              Column(
                children: workouts
                    .map(
                      (workout) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkoutDetailScreen(workout: workout),
                            ),
                          );
                        },
                        child: WorkoutCard(workout: workout),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
