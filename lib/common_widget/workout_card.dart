import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String tss;

  const WorkoutCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.tss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Bar Graph (with fixed blue height and overflowing pink blocks)
          Container(
            height:   80, // max height needed to allow pink blocks to show
            margin: const EdgeInsets.only(bottom: 12),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Blue background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E8FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Pink blocks
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 2,
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: Container(
                          height: 70, // Taller pink block
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5C6DC),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    Flexible(
                      flex: 2,
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: Container(
                          height: 60, // Shorter pink block
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5C6DC),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ],
            ),
          ),

          /// Title & Subtitle
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          /// Duration & TSS Row
          Row(
            children: [
              const Icon(
                CupertinoIcons.clock,
                size: 16,
                color: Color(0xFF9BB5FF),
              ),
              const SizedBox(width: 4),
              Text(
                duration,
                style: const TextStyle(
                  color: Color(0xFF9BB5FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                CupertinoIcons.bolt,
                size: 16,
                color: Color(0xFF9BB5FF),
              ),
              const SizedBox(width: 4),
              Text(
                "TSS: $tss",
                style: const TextStyle(
                  color: Color(0xFF9BB5FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
