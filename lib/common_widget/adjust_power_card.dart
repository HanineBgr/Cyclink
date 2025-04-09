import 'package:flutter/material.dart';
import '../common/colo_extension.dart';

class ModeAndPowerAdjuster extends StatefulWidget {
  const ModeAndPowerAdjuster({Key? key}) : super(key: key);

  @override
  _ModeAndPowerAdjusterState createState() => _ModeAndPowerAdjusterState();
}

class _ModeAndPowerAdjusterState extends State<ModeAndPowerAdjuster> {
  String selectedMode = 'ERG';
  double powerPercentage = 100;

  final List<String> modes = ['ERG', 'SIM', 'Custom'];
  OverlayEntry? _overlayEntry;

  void increasePower() {
    setState(() {
      if (powerPercentage < 150) {
        powerPercentage += 5;
        _showOverlay();
      }
    });
  }

  void decreasePower() {
    setState(() {
      if (powerPercentage > 0) {
        powerPercentage -= 5;
        _showOverlay();
      }
    });
  }

  void _showOverlay() {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: MediaQuery.of(context).size.width * 0.4,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              '${powerPercentage.toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: TColor.primaryColor1,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 5), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 8),
        child: Container(
          height: 95, // Increased height to accommodate the percentage
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF4E9FB), Color(0xFFE3F2FB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Labels Row
              Row(
                children: [
                  Text(
                    'Select Mode',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.22), // Adjust width as needed
                  Text(
                    'Adjust Power',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Elements Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dropdown
                  Container(
                    height: 30,
                    width: screenWidth * 0.3, // Responsive width
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMode,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMode = newValue!;
                          });
                        },
                        items: modes.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(mode),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Power Adjuster (Move icons and text a bit to the right)
                  Row(
                    children: [
                      SizedBox(width: 13 ), // Add this to move the icons and percentage to the right
                      IconButton(
                        icon: Icon(Icons.remove_circle,
                            color: TColor.primaryColor1, size: 25),
                        onPressed: decreasePower,
                      ),
                      // Power Percentage Display (between text and icons)
                      Text(
                        '${powerPercentage.toInt()}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TColor.primaryColor1,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle,
                            color: TColor.primaryColor1, size: 25),
                        onPressed: increasePower,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
