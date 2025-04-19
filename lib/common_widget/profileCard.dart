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
        _zoneCard("Z1", "Recovery", ftp, 0, 55, Colors.blue, Colors.blue[50]!, "Très facile, conversation fluide. Récupération active"),
        _zoneCard("Z2", "Endurance", ftp, 56, 75, Colors.green, Colors.green[50]!, "Effort modéré. Endurance aérobie"),
        _zoneCard("Z3", "Tempo", ftp, 76, 90, Colors.orange, Colors.orange[50]!, "Effort soutenu. Seuil lactique"),
        _zoneCard("Z4", "Threshold", ftp, 91, 105, Colors.red, Colors.red[50]!, "Effort difficile. Seuil anaérobie"),
        _zoneCard("Z5", "VO2 Max", ftp, 106, 120, Colors.purple, Colors.purple[50]!, "Très intense. Capacité aérobie maximale"),
        _zoneCard("Z6", "Anaerobic", ftp, 121, 150, Colors.teal, Colors.teal[50]!, "Maximal court. Tolérance lactique"),
        _zoneCard("Z7", "Neuromuscular", ftp, 151, 200, Colors.brown, Colors.brown[50]!, "Sprints explosifs. Puissance maximale"),
      ];
    } else {
      return [
        _zoneCard("Z1", "Recovery", maxHr, 50, 60, Colors.pink, Colors.pink[50]!, "Très facile. Récupération active"),
        _zoneCard("Z2", "Endurance", maxHr, 61, 70, Colors.orange, Colors.orange[50]!, "Modéré. Endurance aérobie"),
        _zoneCard("Z3", "Tempo", maxHr, 71, 80, Colors.deepPurple, Colors.deepPurple[50]!, "Soutenu. Amélioration du seuil"),
        _zoneCard("Z4", "Threshold", maxHr, 81, 90, Colors.indigo, Colors.indigo[50]!, "Difficile. Seuil anaérobie"),
        _zoneCard("Z5", "VO2 Max", maxHr, 91, 100, Colors.red, Colors.red[50]!, "Très intense. VO2 max"),
      ];
    }
  }

  Widget _zoneCard(String index, String title, int base, int minPct, int maxPct, Color titleColor, Color bgColor, String description) {
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
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Range (%FTP): ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: const Color.fromARGB(255, 113, 112, 112),
                        ),
                      ),
                      TextSpan(
                        text: "$minPct% - $maxPct%\n",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                        color: const Color.fromARGB(255, 113, 112, 112),
                        ),
                      ),
                      TextSpan(
                        text: "Power Range: ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                         color: const Color.fromARGB(255, 113, 112, 112),
                        ),
                      ),
                      TextSpan(
                        text: "$minW - $maxW W\n",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color.fromARGB(255, 113, 112, 112),
                        ),
                      ),
                      TextSpan(
                        text: "Description: ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: const Color.fromARGB(255, 113, 112, 112),
                        ),
                      ),
                      TextSpan(
                        text: description,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
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
