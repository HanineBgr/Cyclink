import 'package:flutter/material.dart';

class TrainingStatus extends StatelessWidget {
  const TrainingStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Training load status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: const [
              Expanded(child: LoadStatusCard(label: 'Fitness (CTL)', value: '150')),
              SizedBox(width: 8),
              Expanded(child: LoadStatusCard(label: 'Fatigue (ATL)', value: '200')),
              SizedBox(width: 8),
              Expanded(child: LoadStatusCard(label: 'Form \n(TSB)', value: '50')),
              SizedBox(width: 8),
              Expanded(child: LoadStatusCard(label: 'Current status', value: 'Neutral')),
            ],
          ),
        ),
      ],
    );
  }
}

class LoadStatusCard extends StatelessWidget {
  final String label;
  final String value;

  const LoadStatusCard({required this.label, required this.value});

  Color _getBackgroundColor() {
    if (label == 'Fitness (CTL)') return Color.fromARGB(255, 227, 243, 255);
    if (label == 'Fatigue (ATL)') return Color.fromARGB(255, 247, 224, 226);
    if (label.replaceAll('\n', ' ') == 'Form (TSB)') {
      return Color.fromARGB(255, 229, 248, 229);
    }
    return Color.fromARGB(255, 254, 252, 225);
  }

  Color _getTextColor() {
    if (label == 'Fitness (CTL)') return Colors.blue.shade800;
    if (label == 'Fatigue (ATL)') return Colors.red.shade800;
    if (label.replaceAll('\n', ' ') == 'Form (TSB)') {
      return Colors.green.shade800;
    }
    return Colors.orange.shade800;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(color: textColor, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
