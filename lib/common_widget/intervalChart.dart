import 'package:flutter/material.dart';

class IntervalGraphCard extends StatelessWidget {
  const IntervalGraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        const Text(
          "Interval",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF151531),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F5FF),
            borderRadius: BorderRadius.circular(24),
          ),
          child: SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _Bar(height: 60),
                SizedBox(width: 12),
                _Bar(height: 120),
                SizedBox(width: 12),
                _Bar(height: 90),
                SizedBox(width: 12),
                _Bar(height: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  const _Bar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Color(0xFFD8B4F8).withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
 // adding two colors to the interval : remaining color ( comme dans l'ullistration)