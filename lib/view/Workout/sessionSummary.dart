import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/heartRateChart.dart';
import '../../common_widget/powerZone.dart';
import '../../common_widget/power_heart_zone.dart';

class SessionSummaryScreen extends StatelessWidget {
  final Map eObj;

  const SessionSummaryScreen({super.key, required this.eObj});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
          eObj["name"].toString(),
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGeneralDetailsCard(),
            const SizedBox(height: 8),
            _buildMetricCard(
              icon: Icons.bolt,
              title: 'Power',
              color: const Color.fromARGB(255, 247, 244, 213),
              iconAndTextColor: Colors.amber.shade800,
              data: 'Normalized: 197 w\nAverage: 174 w\nMaximum: 342 w\nWork: 470 kJ',
            ),
            const SizedBox(height: 8),
            _buildMetricCard(
              icon: Icons.favorite,
              title: 'Heart rate',
              color: const Color.fromARGB(255, 255, 232, 235),
              iconAndTextColor: Colors.red.shade700,
              data: 'Average: 157 bpm\nMaximum: 178 bpm\n Minumun: 120 bpm \n% L/R : 53/47 ',
            ),
            const SizedBox(height: 8),
            _buildMetricCard(
              icon: Icons.speed,
              title: 'Cadence and speed',
              color: Colors.blue.shade50,
              iconAndTextColor: Colors.blue.shade700,
              data: 'Average: 91 rpm\nMaximum: 118 rpm\nAvg speed: 35.2 km/h\nDistance: 26.4 km',
            ),
            const SizedBox(height: 8),
            
            // chart   
            PowerHeartchart(),
     const SizedBox(height: 8),
            // power zones 
          PowerZoneCard(
  percentages: [53, 47],
  colors: [Colors.blue, Colors.red],
  sessionDetails: [
    PowerZoneSessionDetail(
      title: "Recovery",
      zoneColors: [TColor.primaryColor1, Color.fromARGB(255, 247, 208, 208)],
      iconColor: Colors.blue,

    ),
    PowerZoneSessionDetail(
      title: "VO2 max",
      zoneColors: [TColor.primaryColor1, Color.fromARGB(255, 247, 208, 208)],
      iconColor: Colors.red,

    ),
  ],
),
            const SizedBox(height: 4), 
            /// heart rate card 
HeartRateCard(
  colors: [
   TColor.primaryColor1, // Zone 1
    Color.fromARGB(255, 126, 230, 130), // Zone 2
    Colors.yellow, // Zone 3
    Colors.red,    // Zone 4
    Colors.orange, // Zone 5
  ],
  sessionDetails: [
    HeartRateSessionDetail(
      title: 'Recovery',
      zoneColors: [Colors.blue.shade100, Colors.blue.shade600],
      iconColor: TColor.primaryColor1,
    ),
    HeartRateSessionDetail(
      title: 'Endurance',
      zoneColors: [Colors.green.shade100, Colors.green.shade600],
      iconColor: Color.fromARGB(255, 126, 230, 130),
    ),
    HeartRateSessionDetail(
      title: 'Tempo',
      zoneColors: [Colors.yellow.shade100, Colors.yellow.shade600],
      iconColor: Colors.yellow,
    ),
    HeartRateSessionDetail(
      title: 'Threshold',
      zoneColors: [Colors.orange.shade100, Colors.orange.shade600],
      iconColor: Colors.orange,
    ),
    HeartRateSessionDetail(
      title: 'VO2 Max ',
      zoneColors: [Colors.red.shade100, Colors.red.shade600],
      iconColor: Colors.red,
    ),
  ],
),
   ], 
        ),
      ),
    );
  }

  Widget _buildGeneralDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: TColor.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailIcon(Icons.calendar_today, '12 March, 7:35pm'),
                _buildDetailIcon(Icons.timer, '45 min'),
                _buildDetailIcon(Icons.flash_on, 'TSS: 72'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDetailIcon(Icons.local_fire_department, 'Calories: 682'),
                _buildDetailIcon(Icons.bolt, 'IF: 0.93'),
                _buildDetailIcon(Icons.bolt, 'NP:120'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: TColor.primaryColor1, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
  required IconData icon,
  required String title,
  required Color color,
  required Color iconAndTextColor,
  required String data,
}) {
  List<String> lines = data.split('\n');
  List<String> leftData = [];
  List<String> rightData = [];

  for (int i = 0; i < lines.length; i++) {
    if (i % 2 == 0) {
      leftData.add(lines[i]);
    } else {
      rightData.add(lines[i]);
    }
  }

  return Card(
    color: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(8.0), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: iconAndTextColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: iconAndTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Reduced space between title and data
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),  // Adjust padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: leftData
                        .map((item) => _buildIconLabelRow(item))
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),  // Adjust padding to move data right
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rightData
                        .map((item) => _buildIconLabelRow(item))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildIconLabelRow(String line) {
    List<String> parts = line.split(':');
    String label = parts.first.trim();
    String value = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "$label: ",
                style: TextStyle(
                  //fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 94, 94, 94), 
                ),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ),
    );
  }

  
  
}


// remove the percentages and add only one axis(x) : time 
// remove the search from the tab bar 