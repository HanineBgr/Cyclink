import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/common_widget/range_slider.dart';
import 'package:fast_rhino/providers/workout_provider.dart';
import 'package:flutter/material.dart';

class WorkoutSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final WorkoutProvider workoutProvider;

  const WorkoutSearchBar({
    super.key,
    required this.controller,
    required this.workoutProvider,
  });

  @override
  State<WorkoutSearchBar> createState() => _WorkoutSearchBarState();
}

class _WorkoutSearchBarState extends State<WorkoutSearchBar> {
  bool showFilter = false;
  double selectedTss = 100;
  double selectedDuration = 90;

  void _applyFilter() {
    widget.workoutProvider.filterWorkouts(
      minTss: 0,
      maxTss: selectedTss.toInt(),
      minDuration: 0,
      maxDuration: selectedDuration.toInt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    onSubmitted: (value) {
                      final searchText = value.trim();
                      if (searchText.isNotEmpty) {
                        widget.workoutProvider.searchWorkoutsByName(searchText);
                      } else {
                        widget.workoutProvider.fetchWorkouts();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Search Workout",
                      border: InputBorder.none,
                      prefixIcon: GestureDetector(
                        onTap: () {
                          final searchText = widget.controller.text.trim();
                          if (searchText.isNotEmpty) {
                            widget.workoutProvider.searchWorkoutsByName(searchText);
                          } else {
                            widget.workoutProvider.fetchWorkouts();
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
                  onTap: () {
                    setState(() {
                      showFilter = !showFilter;
                    });
                  },
                  child: Image.asset("assets/img/Filter.png", width: 25, height: 25),
                )
              ],
            ),
          ),
        ),
        if (showFilter)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              children: [
                CustomRangeSlider(
                  title: "TSS range",
                  min: 0,
                  max: 200,
                  initialValue: selectedTss,
                  labels: const ["Regular", "Low", "High", "Very high"],
                  activeColor: TColor.primaryColor1,
                  onChanged: (value) {
                    setState(() {
                      selectedTss = value;
                    });
                    _applyFilter(); // 🟢 Dynamic filter on change
                  },
                ),
                const SizedBox(height: 16),
                CustomRangeSlider(
                  title: "Duration range ",
                  min: 0,
                  max: 180,
                  initialValue: selectedDuration,
                  labels: const ["Short", "medium", "long ", "epic"],
                  activeColor: TColor.primaryColor2,
                  onChanged: (value) {
                    setState(() {
                      selectedDuration = value;
                    });
                    _applyFilter(); // 🟢 Dynamic filter on change
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
