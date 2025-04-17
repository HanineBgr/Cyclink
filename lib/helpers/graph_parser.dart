import 'package:xml/xml.dart';

List<Map<String, dynamic>> extractWorkoutGraphData(String xmlString) {
  final List<Map<String, dynamic>> data = [];

  try {
    final document = XmlDocument.parse(xmlString);
    final workout = document.findAllElements('workout').first;

    int elapsedTime = 0;

    for (var element in workout.children.whereType<XmlElement>()) {
      final name = element.name.local;

      if (name == 'Warmup' || name == 'Cooldown') {
        final duration = int.parse(element.getAttribute('Duration') ?? '0');
        final low = double.parse(element.getAttribute('PowerLow') ?? '0');
        final high = double.parse(element.getAttribute('PowerHigh') ?? '0');

        data.add({
          "time": elapsedTime,
          "power": low,
          "type": name,
        });
        data.add({
          "time": elapsedTime + duration,
          "power": high,
          "type": name,
        });

        elapsedTime += duration;
      } else if (name == 'SteadyState') {
        final duration = int.parse(element.getAttribute('Duration') ?? '0');
        final power = double.parse(element.getAttribute('Power') ?? '0');

        data.add({
          "time": elapsedTime,
          "power": power,
          "type": name,
        });
        data.add({
          "time": elapsedTime + duration,
          "power": power,
          "type": name,
        });

        elapsedTime += duration;
      } else if (name == 'IntervalsT') {
        final repeat = int.parse(element.getAttribute('Repeat') ?? '0');
        final onDuration = int.parse(element.getAttribute('OnDuration') ?? '0');
        final offDuration = int.parse(element.getAttribute('OffDuration') ?? '0');
        final onPower = double.parse(element.getAttribute('OnPower') ?? '0');
        final offPower = double.parse(element.getAttribute('OffPower') ?? '0');

        for (int i = 0; i < repeat; i++) {
          data.add({
            "time": elapsedTime,
            "power": onPower,
            "type": "IntervalsT",
          });
          elapsedTime += onDuration;
          data.add({
            "time": elapsedTime,
            "power": onPower,
            "type": "IntervalsT",
          });

          data.add({
            "time": elapsedTime,
            "power": offPower,
            "type": "IntervalsT",
          });
          elapsedTime += offDuration;
          data.add({
            "time": elapsedTime,
            "power": offPower,
            "type": "IntervalsT",
          });
        }
      }
    }
  } catch (e) {
    print("❌ XML parsing failed: $e");
  }

  return data;
}
