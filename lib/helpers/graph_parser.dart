import 'package:xml/xml.dart';

List<Map<String, dynamic>> extractWorkoutGraphData(String xmlString) {
  final List<Map<String, dynamic>> data = [];
  int elapsedTime = 0;

  try {
    final document = XmlDocument.parse(xmlString);
    final workout = document.findAllElements('workout').first;

    for (var element in workout.children.whereType<XmlElement>()) {
      final tag = element.name.local;

      if (tag == 'Warmup' || tag == 'Cooldown') {
        final duration = int.tryParse(element.getAttribute('Duration') ?? '') ?? 0;
        final low = double.tryParse(element.getAttribute('PowerLow') ?? '') ?? 0;
        final high = double.tryParse(element.getAttribute('PowerHigh') ?? '') ?? 0;

        data.add({"time": elapsedTime, "power": low});
        data.add({"time": elapsedTime + duration, "power": high});

        elapsedTime += duration;
      }

      if (tag == 'SteadyState') {
        final duration = int.tryParse(element.getAttribute('Duration') ?? '') ?? 0;
        final power = double.tryParse(element.getAttribute('Power') ?? '') ?? 0;

        data.add({"time": elapsedTime, "power": power});
        data.add({"time": elapsedTime + duration, "power": power});

        elapsedTime += duration;
      }

      if (tag == 'IntervalsT') {
        final repeat = int.tryParse(element.getAttribute('Repeat') ?? '') ?? 0;
        final onDuration = int.tryParse(element.getAttribute('OnDuration') ?? '') ?? 0;
        final offDuration = int.tryParse(element.getAttribute('OffDuration') ?? '') ?? 0;
        final onPower = double.tryParse(element.getAttribute('OnPower') ?? '') ?? 0;
        final offPower = double.tryParse(element.getAttribute('OffPower') ?? '') ?? 0;

        for (int i = 0; i < repeat; i++) {
          // ON
          data.add({"time": elapsedTime, "power": onPower});
          elapsedTime += onDuration;
          data.add({"time": elapsedTime, "power": onPower});

          // OFF
          data.add({"time": elapsedTime, "power": offPower});
          elapsedTime += offDuration;
          data.add({"time": elapsedTime, "power": offPower});
        }
      }
    }
  } catch (e) {
    print("❌ XML parsing error: $e");
  }

  return data;
}
