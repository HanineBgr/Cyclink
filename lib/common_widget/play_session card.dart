import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlaySessionCard extends StatelessWidget {
  const PlaySessionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Container(
      height: 55, 
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4E9FB), Color(0xFFE3F2FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        mainAxisAlignment: MainAxisAlignment.center, // Center the icons vertically
        children: [
          // Add clickable icons (play, accelerate, stop)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Play icon
              InkWell(
                onTap: () {
                  // Add your play logic here
                  print('Play tapped');
                },
                child: Icon(
                  Icons.play_arrow,
                  size: 30, // Slightly reduced icon size
                  color: Color(0xFF9BB5FF),
                ),
              ),

     
              InkWell(
                onTap: () {
                  // Add your accelerate logic here
                  print('Accelerate tapped');
                },
                child: Icon(
                  Icons.fast_forward,
                  size: 30, // Slightly reduced icon size
                  color: Color(0xFF9BB5FF),
                ),
              ),

              // Stop icon
              InkWell(
                onTap: () {
                  // Add your stop logic here
                  print('Stop tapped');
                },
                child: Icon(
                  Icons.stop,
                  size: 30, // Slightly reduced icon size
                  color: Color(0xFF9BB5FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
