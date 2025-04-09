import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PowerZoneCard extends StatelessWidget {
  final List<int> percentages;
  final List<Color> colors;
  final List<PowerZoneSessionDetail> sessionDetails;

  const PowerZoneCard({
    super.key,
    required this.percentages,
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
              'Power zones',
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
        children: percentages.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          final color = colors[index];
          final percentageText = "$value%";

          return Expanded(
            flex: value,
            child: Container(
              height: 14,
              color: color,
              alignment: Alignment.center,
              child: value >= 10
                  ? Text(
                      percentageText,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSessionDetail(int number, PowerZoneSessionDetail detail) {
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

class PowerZoneSessionDetail {
  final String title;
  final List<Color> zoneColors;
  final Color? iconColor;

  PowerZoneSessionDetail({
    required this.title,
    required this.zoneColors,
    this.iconColor,
  });
}
