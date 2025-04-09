import 'package:fast_rhino/common/colo_extension.dart';
import 'package:flutter/material.dart';

class RecentActivities extends StatelessWidget {
  final String activityName;
  final String activityDate;
  final String buttonLabel;
  final Color buttonColor;
  final Color textColor;
  final IconData activityIcon; 
  final String effortLabel = "Effort"; 
  const RecentActivities({
    Key? key,
    required this.activityName,
    required this.activityDate,
    required this.buttonLabel,
    required this.buttonColor,
    required this.textColor,
    required this.activityIcon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    double buttonWidth = screenWidth * 0.14;
    double buttonHeight = screenWidth * 0.05; 
    double fontSize = screenWidth * 0.032;

    return Container(
      
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 244, 226, 232),
              shape: BoxShape.circle,
            ),
            child: Icon(activityIcon, color: TColor.secondaryColor2, size: screenWidth * 0.06), // Use passed icon
          ),

          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  activityName,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Row(
                  children: [
                    Text(
                      activityDate,
                      style: TextStyle(color: Colors.black54, fontSize: fontSize * 0.9),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Icon(Icons.access_time, size: fontSize, color: Colors.black54),
                    SizedBox(width: screenWidth * 0.01),
                    Text("54", style: TextStyle(color: Colors.black54, fontSize: fontSize * 0.9)),
                    SizedBox(width: screenWidth * 0.02),
                    Icon(Icons.bolt, size: fontSize, color: Colors.black54),
                    SizedBox(width: screenWidth * 0.01),
                    Text("42", style: TextStyle(color: Colors.black54, fontSize: fontSize * 0.9)),
                  ],
                ),
              ],
            ),
          ),
          // Column for vertically aligned buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Align buttons vertically
            children: [
              // Strava button
              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttonLabel,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize * 0.85,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenheight * 0.01), 
              // Effort button
              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    effortLabel,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize * 0.85,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: screenWidth * 0.02),
          Icon(Icons.arrow_forward_ios, color: TColor.secondaryColor1, size: fontSize * 0.9),
        ],
      ),
    );
  }
}
// add title 'recent activities' and make the card clickable 
//to navigate to the history screen  
// recent activties dans un container avec une entete ( les activites de la derniere semaine à partir d'aujourd'hui)
