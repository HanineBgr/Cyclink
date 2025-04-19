import 'package:fast_rhino/helpers/power_zone.dart';
import 'package:fast_rhino/models/Workout/interval.dart';
import 'package:xml/xml.dart';


double? _getAttributeDouble(XmlElement element, String attributeName) {
  final value = element.getAttribute(attributeName);
  if (value == null) return null;
  try {
    return double.parse(value);
  } catch (_) {
    return null;
  }
}

WorkoutInterval _parseWarmupElement(XmlElement element) {
  final duration = _getAttributeDouble(element, 'Duration') ?? 0;
  final low = _getAttributeDouble(element, 'PowerLow') ?? 0.5;
  final high = _getAttributeDouble(element, 'PowerHigh') ?? 0.75;
  final avg = (low + high) / 2 * 100;
  return WorkoutInterval(
    type: 'Warmup',
    duration: duration / 60,
    power: avg,
    zone: PowerZones.forPower(avg),
    isRamp: true,
    startPower: low * 100,
    endPower: high * 100,
  );
}

WorkoutInterval _parseSteadyStateElement(XmlElement element) {
  final duration = _getAttributeDouble(element, 'Duration') ?? 0;
  final power = _getAttributeDouble(element, 'Power') ?? 0.7;
  final percent = power * 100;
  return WorkoutInterval(
    type: 'SteadyState',
    duration: duration / 60,
    power: percent,
    zone: PowerZones.forPower(percent),
    isRamp: false,
    startPower: percent,
    endPower: percent,
  );
}

WorkoutInterval _parseRampElement(XmlElement element) {
  final duration = _getAttributeDouble(element, 'Duration') ?? 0;
  final low = _getAttributeDouble(element, 'PowerLow') ?? 0.5;
  final high = _getAttributeDouble(element, 'PowerHigh') ?? 1.0;
  final avg = ((low + high) / 2) * 100;
  return WorkoutInterval(
    type: 'Ramp',
    duration: duration / 60,
    power: avg,
    zone: PowerZones.forPower(avg),
    isRamp: true,
    startPower: low * 100,
    endPower: high * 100,
  );
}

WorkoutInterval _parseCooldownElement(XmlElement element) {
  final duration = _getAttributeDouble(element, 'Duration') ?? 0;
  final low = _getAttributeDouble(element, 'PowerLow') ?? 0.5;
  final high = _getAttributeDouble(element, 'PowerHigh') ?? 0.75;
  final avg = (low + high) / 2 * 100;
  return WorkoutInterval(
    type: 'Cooldown',
    duration: duration / 60,
    power: avg,
    zone: PowerZones.forPower(avg),
    isRamp: true,
    startPower: high * 100,
    endPower: low * 100,
  );
}

WorkoutInterval _parseFreeRideElement(XmlElement element) {
  final duration = _getAttributeDouble(element, 'Duration') ?? 0;
  return WorkoutInterval(
    type: 'FreeRide',
    duration: duration / 60,
    power: 0,
    zone: PowerZones.z1,
    isRamp: false,
    startPower: 0,
    endPower: 0,
  );
}

List<WorkoutInterval> parseWorkoutXml(String xml) {
  final document = XmlDocument.parse(xml);
  final workout = document.findAllElements('workout').first;
  final List<WorkoutInterval> result = [];

  for (final e in workout.children.whereType<XmlElement>()) {
    switch (e.name.local) {
      case 'Warmup': result.add(_parseWarmupElement(e)); break;
      case 'SteadyState': result.add(_parseSteadyStateElement(e)); break;
      case 'Ramp': result.add(_parseRampElement(e)); break;
      case 'Cooldown': result.add(_parseCooldownElement(e)); break;
      case 'FreeRide':
      case 'MaxEffort':
      case 'RestDay': result.add(_parseFreeRideElement(e)); break;
    }
  }
  return result;
}
