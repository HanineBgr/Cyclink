import 'package:fast_rhino/models/user/user.dart';
import 'package:fast_rhino/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';


class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
    required String gender,
    required DateTime dateOfBirth,
    required double weight,
    required double height,
    required int ftp,
    int? maxHR,
    int? restingHR,
    required Map<String, dynamic> preferences,
  }) async {
    final response = await AuthService.signUp(
      email: email,
      name: name,
      password: password,
      gender: gender,
      dateOfBirth: dateOfBirth,
      weight: weight,
      height: height,
      ftp: ftp,
      maxHR: maxHR ?? 0, 
      restingHR: restingHR ?? 0,
      preferences: preferences,
    );

    // Create user instance from response
    _user = User.fromJson(response['user']);
    // Optionally store token here if your signup endpoint returns one
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final response = await AuthService.signIn(email: email, password: password);
    _token = response['token'];
    _user = User.fromJson(response['user']);
    notifyListeners();
  }

  void signOut() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
