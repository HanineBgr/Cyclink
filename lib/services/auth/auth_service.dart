import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  /// Change this baseUrl to your backend address.
  static const String baseUrl = 'http://192.168.1.13:5000';

  /// Sign Up API Call
  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String name,
    required String password,
    required String gender,
    required DateTime dateOfBirth,
    required double weight,
    required double height,
    required int ftp,
    required int maxHR,
    required int restingHR,
    required Map<String, dynamic> preferences,
  }) async {
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
        'gender': gender,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'weight': weight,
        'height': height,
        'ftp': ftp,
        'max_hr': maxHR,
        'resting_hr': restingHR,
        'preferences': preferences,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Sign-up failed');
    }
  }

  /// Sign In API Call
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Sign-in failed');
    }
  }
}
