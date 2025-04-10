// lib/services/zwo_parser.dart
import 'package:fast_rhino/models/workout.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:xml/xml.dart';

Future<Workout> loadWorkout(String assetPath) async {
  try {
    // Load the ZWO file as a string from assets
    final xmlString = await rootBundle.rootBundle.loadString(assetPath);

    // Debug log to verify content of the ZWO file
    print('Loaded XML content: $xmlString');

    // Parse the XML string into an XmlDocument
    final document = XmlDocument.parse(xmlString);

    // Debug log to verify parsed XML structure
    print('Parsed XML document: ${document.toXmlString()}');

    // Use the Workout model's fromXml factory to convert the XML to a Workout object
    return Workout.fromXml(document);
  } catch (e) {
    print('Error loading workout from $assetPath: $e');
    rethrow; // Rethrow error for handling in the FutureBuilder
  }
}
