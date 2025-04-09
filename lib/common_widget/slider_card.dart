import 'package:flutter/material.dart';

import '../common/colo_extension.dart';
import '../view/Workout/trainingSession.dart';

class SessionSliderCard extends StatelessWidget {
  const SessionSliderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: const Text(
            "Start your session",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF151531),
            ),
          ),
        ),
        const SizedBox(height: 2),

        /// Stack to center play icon only
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  TrainingSessionScreen(eObj: {"name": "Training session"})),
                );
              },
              child: Icon(
                Icons.play_arrow,
                size: 70,
                color: TColor.primaryColor1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}