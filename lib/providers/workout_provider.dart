import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Workout/workout.dart';

// 🌍 Base URL à modifier si nécessaire
const String baseUrl = 'http://192.168.1.13:5000';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  bool _isLoading = false;

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;

  /// 📦 Fetch All Workouts
  Future<void> fetchWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$baseUrl/workouts'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _workouts = data.map((w) => Workout.fromJson(w)).toList();
      } else {
        throw Exception('Failed to load workouts');
      }
    } catch (e) {
      print("❌ Error fetching workouts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
Future<void> filterWorkouts({
  required int minTss,
  required int maxTss,
  required int minDuration,
  required int maxDuration,
}) async {
  _isLoading = true;
  notifyListeners();

  try {
    final uri = Uri.parse(
        'http://192.168.1.13:5000/workouts/filter?minTss=$minTss&maxTss=$maxTss&minDuration=$minDuration&maxDuration=$maxDuration');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _workouts = data.map((json) => Workout.fromJson(json)).toList();
    } else {
      throw Exception("Failed to filter workouts");
    }
  } catch (e) {
    print("❌ Error filtering workouts: $e");
  }

  _isLoading = false;
  notifyListeners();
}

  /// 🔍 Search Workouts by Name
  Future<void> searchWorkoutsByName(String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/workouts/search?name=$name'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _workouts = data.map((json) => Workout.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load workouts");
      }
    } catch (e) {
      print("❌ Error searching workouts: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
