import 'package:fast_rhino/common/colo_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isPowerZoneSelected = true;

  @override
  Widget build(BuildContext context) {
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
              // Title
              Text(
                'Training zones',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              // Subtitle
              Text(
                'Power zones based on your FTP and LTHR.',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),

              // Toggle Buttons
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

              // Zone cards
              ..._buildZoneCards(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildZoneCards() {
    if (isPowerZoneSelected) {
      return [
        _zoneCard(
          index: '1',
          title: 'Recovery',
          titleColor: Colors.blue,
          bgColor: Colors.blue[50]!,
        ),
        _zoneCard(
          index: '2',
          title: 'Endurance',
          titleColor: Colors.green,
          bgColor: Colors.green[50]!,
        ),
        _zoneCard(
          index: '3',
          title: 'Tempo',
          titleColor: Colors.yellow[800]!,
          bgColor: Colors.yellow[50]!,
        ),
      ];
    } else {
      return [
        _zoneCard(
          index: '1',
          title: 'Zone 1',
          titleColor: Colors.pink,
          bgColor: Colors.pink[50]!,
        ),
        _zoneCard(
          index: '2',
          title: 'Zone 2',
          titleColor: Colors.orange,
          bgColor: Colors.orange[50]!,
        ),
        _zoneCard(
          index: '3',
          title: 'Zone 3',
          titleColor: Colors.deepPurple,
          bgColor: Colors.deepPurple[50]!,
        ),
      ];
    }
  }

Widget _zoneCard({
  required String index,
  required String title,
  required Color titleColor,
  required Color bgColor,
}) {
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
        // Circle number
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
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Range (% FTP) : 25% - 55%\nPower Range: 71 – 157 W\nDescription: Very low intensity',
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
    );
  }
}
