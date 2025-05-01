import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isPowerZoneSelected = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final ftp = user?.ftp ?? 200;
    final maxHr = user?.maxHR ?? 180;

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Training zones',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Power zones based on your FTP and LTHR.',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isPowerZoneSelected = true),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isPowerZoneSelected ? TColor.primaryColor1 : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Power zones',
                            style: GoogleFonts.poppins(
                              color: isPowerZoneSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isPowerZoneSelected = false),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isPowerZoneSelected ? TColor.primaryColor1 : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Heart rate zones',
                            style: GoogleFonts.poppins(
                              color: !isPowerZoneSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ..._buildZoneCards(ftp, maxHr),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildZoneCards(int ftp, int maxHr) {
    if (isPowerZoneSelected) {
      return [
        _zoneCard("Z1", "Recovery:", "Récupération active", ftp, 0, 55, Colors.blue, Colors.blue[50]!),
        _zoneCard("Z2", "Endurance:", "Endurance aérobie", ftp, 56, 75, Colors.green, Colors.green[50]!),
        _zoneCard("Z3", "Tempo:", "Seuil lactique", ftp, 76, 90, Colors.orange, Colors.orange[50]!),
        _zoneCard("Z4", "Threshold:", "Seuil anaérobie", ftp, 91, 105, Colors.red, Colors.red[50]!),
        _zoneCard("Z5", "VO2 Max:", "Très intense", ftp, 106, 120, Colors.purple, Colors.purple[50]!),
        _zoneCard("Z6", "Anaerobic:", "Tolérance lactique", ftp, 121, 150, Colors.brown, Colors.brown[50]!),
        _zoneCard("Z7", "Neuromuscular:", "Sprints explosifs", ftp, 151, 200, Colors.grey, Colors.grey[50]!),
      ];
    } else {
      return [
        _zoneCard("Z1", "Recovery:", "Récupération active", maxHr, 50, 60, Colors.blue, Colors.blue[50]!),
        _zoneCard("Z2", "Endurance:", "Endurance aérobie", maxHr, 61, 70, Colors.green, Colors.green[50]!),
        _zoneCard("Z3", "Tempo:", "Amélioration du seuil", maxHr, 71, 80, Colors.orange, Colors.orange[50]!),
        _zoneCard("Z4", "Threshold:", "Seuil anaérobie", maxHr, 81, 90, Colors.red, Colors.red[50]!),
        _zoneCard("Z5", "VO2 Max:", "Très intense. VO2 max", maxHr, 91, 100, Color(0xFFDC143C), Colors.red[50]!),
      ];
    }
  }

  Widget _zoneCard(String index, String title, String description, int base, int minPct, int maxPct, Color titleColor, Color bgColor) {
    final minW = (base * minPct / 100).round();
    final maxW = (base * maxPct / 100).round();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: titleColor,
            ),
            alignment: Alignment.center,
            child: Text(
              index,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$title ",
                        style: GoogleFonts.poppins(
                          color: titleColor, // ✅ Matches circle color
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: description,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Zone Range: $minPct–$maxPct%" + (isPowerZoneSelected ? "  ($minW–$maxW W)" : ""),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
