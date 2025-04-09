import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fast_rhino/common/colo_extension.dart';
import '../../common_widget/adjust_power_card.dart';
import '../../common_widget/play_session card.dart';

class TrainingSessionScreen extends StatefulWidget {
  final Map eObj;
  const TrainingSessionScreen({super.key, required this.eObj});

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
  int instructionIndex = 0;
  bool showInstruction = false;
  Timer? _instructionTimer;
  Timer? _hideInstructionTimer;

  final List<String> instructions = [
    "Let’s make today count!",
    "Push your limits!",
    "Stay focused and breathe.",
    "You’re doing great! Keep going!",
  ];

  @override
  void initState() {
    super.initState();
    startInstructionAlertCycle();
  }

  void startInstructionAlertCycle() {
    _instructionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      for (int i = 0; i < 3; i++) {
        Future.delayed(Duration(seconds: i), () {
          print('Bip ${i + 1}'); // Replace with your audio logic
        });
      }

      setState(() {
        instructionIndex = (instructionIndex + 1) % instructions.length;
        showInstruction = true;
      });

      _hideInstructionTimer?.cancel();
      _hideInstructionTimer = Timer(const Duration(seconds: 5), () {
        setState(() {
          showInstruction = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _instructionTimer?.cancel();
    _hideInstructionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : theme.scaffoldBackgroundColor, // Dark mode background
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : theme.scaffoldBackgroundColor, // Dark mode app bar
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.eObj["name"].toString(),
          style: TextStyle(
            color: isDark ? Colors.white : theme.textTheme.titleLarge?.color,  // Dynamically adapting text color
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Consistent padding for the entire body
        child: Center(
          child: SizedBox(
            height: screenHeight * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatsCard(isDark),
                if (showInstruction) _buildInstructionAlert(theme, isDark),
                _buildIntervalBar(),
                _buildProgressBar(),
                PlaySessionCard(),
                ModeAndPowerAdjuster(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : TColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [if (!isDark) const BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(3),
        },
        border: TableBorder.all(color: TColor.lightGray, width: 1),
        children: [
          _buildTableRow("Target power", "200", "Power 3Sec", "98", "BPM", "169"),
          _buildTableRow("Target RPM", "98", "RPM", "105", "Speed (km/h)", "25"),
          _buildTableRow("Interval", "12/43", "Remaining", "45:30", "Session", "45:30"),
        ],
      ),
    );
  }

  Widget _buildInstructionAlert(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16), // Added vertical margin
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(instructions[instructionIndex], style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildIntervalBar() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(painter: IntervalBarPainter(), child: Container()),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: 0.4,
        minHeight: 8,
        backgroundColor: Colors.grey[300],
        color: TColor.primaryColor1,
      ),
    );
  }

  TableRow _buildTableRow(String title1, String value1, String title2, String value2, String title3, String value3) {
    return TableRow(children: [
      _buildTableCell(title1, value1),
      _buildTableCell(title2, value2),
      _buildTableCell(title3, value3),
    ]);
  }

  Widget _buildTableCell(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: TColor.primaryColor1)),
        ],
      ),
    );
  }
}

class IntervalBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TColor.primaryColor1.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final barWidth = size.width / 6;
    final barHeights = [30.0, 80.0, 80.0, 30.0, 80.0, 30.0];

    for (int i = 0; i < 6; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * barWidth, size.height - barHeights[i], barWidth, barHeights[i]),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
