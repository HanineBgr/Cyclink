import 'package:fast_rhino/helpers/power_zone.dart';
import 'package:flutter/material.dart';

Color getZoneColor(double powerPercent) {
  final zone = PowerZones.forPower(powerPercent);
  return zone.color;
}
