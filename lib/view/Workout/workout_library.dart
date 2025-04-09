import 'package:fast_rhino/view/Workout/beforeSession.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/metrics_row.dart';
import '../../common_widget/power_chart.dart';
import '../../common_widget/range_slider.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/workout_card.dart';

class WorkoutLibrary extends StatefulWidget {
  final Map eObj;

  const WorkoutLibrary({super.key, required this.eObj});

  @override
  State<WorkoutLibrary> createState() => _WorkoutLibraryState();
}

class _WorkoutLibraryState extends State<WorkoutLibrary> {
  TextEditingController txtSearch = TextEditingController();

  List categoryArr = [
    {"name": "Salad", "image": "assets/img/c_1.png"},
    {"name": "Cake", "image": "assets/img/c_2.png"},
    {"name": "Pie", "image": "assets/img/c_3.png"},
    {"name": "Smoothies", "image": "assets/img/c_4.png"},
  ];

  List popularArr = [
    {
      "name": "Blueberry Pancake",
      "image": "assets/img/f_1.png",
      "b_image": "assets/img/pancake_1.png",
      "size": "Medium",
      "time": "30mins",
      "kcal": "230kCal"
    },
    {
      "name": "Salmon Nigiri",
      "image": "assets/img/f_2.png",
      "b_image": "assets/img/nigiri.png",
      "size": "Medium",
      "time": "20mins",
      "kcal": "120kCal"
    },
  ];

  List recommendArr = [
    {
      "name": "Honey Pancake",
      "image": "assets/img/rd_1.png",
      "size": "Easy",
      "time": "30mins",
      "kcal": "180kCal"
    },
    {
      "name": "Canai Bread",
      "image": "assets/img/m_4.png",
      "size": "Easy",
      "time": "20mins",
      "kcal": "230kCal"
    },
  ];

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
                widget.eObj["description"] ??
                    "The 8 minute Functional Threshold Power (FTP) test offers an alternative means of calculating FTP.",
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

            //SizedBox(height:1),

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BeforeSessionScreen(
                        eObj: widget.eObj,
                      ),
                    ),
                  );
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
            SizedBox(height: media.width * 0.02),
           // found workouts Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text("6 workout found",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: media.width * 0.02),
            // Workout List 
            WorkoutCard(duration: '60min', subtitle: 'Solid sweet spot intervals with recovery ', title: 'Sweet spot builder ', tss: '75',),
            SizedBox(height: media.height * 0.02),
            WorkoutCard(duration: '60min', subtitle: 'Building base fitness  ', title: 'Endurance ride ', tss: '75',),
            ],
                  
        ),
      ),
    );
  }
}
