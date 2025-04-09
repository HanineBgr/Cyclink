import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeartRateCard extends StatelessWidget {
  final List<Color> colors;
  final List<HeartRateSessionDetail> sessionDetails;

  const HeartRateCard({
    super.key,
    required this.colors,
    required this.sessionDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white, // Fixed card color to white
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heart Rate Zones',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            _buildZoneBar(),
            const SizedBox(height: 12),
            ...sessionDetails
                .asMap()
                .entries
                .map((entry) => _buildSessionDetail(entry.key + 1, entry.value))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: colors
            .map((color) => Expanded(
                  child: Container(
                    height: 14,
                    color: color,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSessionDetail(int number, HeartRateSessionDetail detail) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 8,
                backgroundColor: detail.iconColor ?? Colors.grey.shade300,
                child: Text(
                  number.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                detail.title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: detail.zoneColors
                  .map((color) => Expanded(
                        child: Container(
                          height: 10,
                          color: color,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartRateSessionDetail {
  final String title;
  final List<Color> zoneColors;
  final Color? iconColor;

  HeartRateSessionDetail({
    required this.title,
    required this.zoneColors,
    this.iconColor,
  });
}
