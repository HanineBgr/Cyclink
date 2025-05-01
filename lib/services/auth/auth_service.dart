// 📁 lib/services/auth/auth_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fast_rhino/models/user/user.dart';

class AuthService {
  static const String baseUrl = 'https://backend-izlg.onrender.com';
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Sign Up
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

  /// Sign In
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
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Sign-in failed');
    }
  }
/// Update user profile
static Future<User> updateUser({
  required String userId,
  required Map<String, dynamic> updatedFields,
}) async {
  final token = await _storage.read(key: 'token');
  final url = Uri.parse('$baseUrl/user/$userId'); // matches /user/:id

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(updatedFields),
  );

  final responseBody = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return User.fromJson(responseBody);
  } else {
    throw Exception(responseBody['message'] ?? 'Failed to update user');
  }
}


  /// Fetch Current User
  static Future<User> fetchUser({required String token}) async {
  final url = Uri.parse('$baseUrl/user');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  final responseBody = jsonDecode(response.body);

  if (response.statusCode == 200) {
    if (responseBody['user'] == null) {
      throw Exception("User data is missing");
    }

    return User.fromJson(responseBody['user']);
  } else {
    throw Exception(responseBody['message'] ?? 'Failed to fetch user');
  }
}


  /// Sign Out
  static Future<void> signOut() async {
    await _storage.delete(key: 'token');
  }

  /// sign in with strava 
  /* static Future<User> signInWithStrava() async {
    const clientId = '156458'; 
    final redirectUri = '$baseUrl/auth/strava/callback';

    final authUrl = Uri.https("www.strava.com", "/oauth/authorize", {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'approval_prompt': 'auto',
      'scope': 'read,activity:read',
    }).toString();

    try {
      final result = await FlutterWebAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: 'https', 
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) throw Exception("Missing code from redirect");

      final tokenResponse = await http.get(
        Uri.parse('$baseUrl/auth/strava/callback?code=$code'),
      );

      if (tokenResponse.statusCode == 200) {
        final data = json.decode(tokenResponse.body);
        final token = data['token'];

        await _storage.write(key: 'token', value: token);
        return User.fromJson(data['user']);
      } else {
        final err = json.decode(tokenResponse.body);
        throw Exception(err['message'] ?? 'Strava login failed');
      }
    } catch (e) {
      throw Exception("Strava auth error: $e");
    }
  }*/
}
