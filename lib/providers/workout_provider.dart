import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Workout/workout.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  bool _isLoading = false;

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;

  Future<void> fetchWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://192.168.1.13:5000/workouts')); // replace with your IP if testing on real device

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
}
