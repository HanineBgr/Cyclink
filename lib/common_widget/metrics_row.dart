import 'package:fast_rhino/common/colo_extension.dart';
import 'package:flutter/material.dart';

class WorkoutMetricsRow extends StatelessWidget {
  const WorkoutMetricsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4E9FB), Color(0xFFE3F2FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _MetricItem(
            icon: Icons.access_time,
            label: "1h20min",
          ),
          _MetricItem(
            icon: Icons.bolt_outlined,
            label: "TSS: 79",
          ),
          _MetricItem(
            icon: Icons.speed,
            label: "IF: 1.39",
          ),
          _MetricItem(
            icon: Icons.flash_on,
            label: "NP: 250",
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetricItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: TColor.primaryColor2),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4F4F4F),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
