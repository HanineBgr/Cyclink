import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fast_rhino/models/user/user.dart';
import 'package:fast_rhino/services/auth/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  User? _user;
  String? _token;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  int get ftp => _user?.ftp ?? 0;

  /// Sign In
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final response = await AuthService.signIn(email: email, password: password);
    _token = response['token'];

    if (_token == null) {
      throw Exception('Sign-in failed: token missing');
    }

    // Save token for future use
    await _storage.write(key: 'token', value: _token);

    _user = User.fromJson(response['user']);
    notifyListeners();
  }

  /// Fetch current user based on saved token
  Future<bool> fetchUser() async {
  _isLoading = true;
  notifyListeners();

  _token ??= await _storage.read(key: 'token');

  if (_token == null) {
    _isLoading = false;
    notifyListeners();
    _user = null;
    return false;
  }

  try {
    final userData = await AuthService.fetchUser(token: _token!);
    _user = userData;
    _isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
    print('❌ Fetch user error: $e');
    _user = null;
    _token = null;
    await _storage.delete(key: 'token');
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  /// Sign Up (token is not returned here, so we don't store it)
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

    _user = User.fromJson(response['user']);
    notifyListeners();
  }

  /// Logout
  Future<void> signOut() async {
    _token = null;
    _user = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }

  /// Update user data
  Future<bool> updateUserProfile(Map<String, dynamic> updatedFields) async {
  if (_user == null) return false;

  try {
    final updatedUser = await AuthService.updateUser(
      userId: _user!.id,
      updatedFields: updatedFields,
    );

    _user = updatedUser;
    notifyListeners();
    return true;
  } catch (e) {
    print('❌ Failed to update profile: $e');
    return false;
  }
}

}
