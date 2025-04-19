import 'package:flutter/material.dart';

class PowerZone {
  final String id;
  final String name;
  final double lowerBound;
  final double upperBound;
  final Color color;

  const PowerZone({
    required this.id,
    required this.name,
    required this.lowerBound,
    required this.upperBound,
    required this.color,
  });

  bool containsPower(double power) {
    return power >= lowerBound && power <= upperBound;
  }
}

class PowerZones {
  static const z1 = PowerZone(id: 'Z1', name: 'Recovery', lowerBound: 0, upperBound: 55, color: Color(0xFF45B7D1));
  static const z2 = PowerZone(id: 'Z2', name: 'Endurance', lowerBound: 56, upperBound: 75, color: Color(0xFF4CAF50));
  static const z3 = PowerZone(id: 'Z3', name: 'Tempo', lowerBound: 76, upperBound: 90, color: Color(0xFFFFD700));
  static const z4 = PowerZone(id: 'Z4', name: 'Threshold', lowerBound: 91, upperBound: 105, color: Color(0xFFFF9800));
  static const z5 = PowerZone(id: 'Z5', name: 'VO2 Max', lowerBound: 106, upperBound: 120, color: Color(0xFFFF5252));
  static const z6 = PowerZone(id: 'Z6', name: 'Anaerobic', lowerBound: 121, upperBound: 150, color: Color(0xFFC2185B));
  static const z7 = PowerZone(id: 'Z7', name: 'Neuromuscular', lowerBound: 151, upperBound: 250, color: Color(0xFF9C27B0));

  static const List<PowerZone> all = [z1, z2, z3, z4, z5, z6, z7];

  static PowerZone forPower(double power) {
    return all.firstWhere((zone) => zone.containsPower(power), orElse: () => z1);
  }
}
