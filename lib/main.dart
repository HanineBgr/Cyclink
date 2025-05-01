import 'package:fast_rhino/providers/workout_provider.dart';
import 'package:fast_rhino/view/Splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/colo_extension.dart';
import 'providers/auth_provider.dart';
import 'view/main_tab/main_tab_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final startupScreen = await _determineInitialScreen();

  runApp(AppWrapper(startScreen: startupScreen));
}

Future<Widget> _determineInitialScreen() async {
  final storage = FlutterSecureStorage();
  final prefs = await SharedPreferences.getInstance();
  final token = await storage.read(key: 'token');

  if (token != null) {
    try {
      // Try fetching the user using the token
      final authProvider = AuthProvider();
      await authProvider.fetchUser();

      if (authProvider.user != null) {
        final lastScreen = prefs.getString('lastScreen');
        final tabIndex = switch (lastScreen) {
          'Profile' => 4,
          'WorkoutLibrary' => 1,
          'Planning' => 3,
          'HomeView' => 0,
          _ => 0,
        };
        return MainTabView(initialTabIndex: tabIndex);
      }
    } catch (e) {
      print("❌ Token exists but user fetch failed: $e");
    }
  }

  return SplashScreen(); 
}

class AppWrapper extends StatelessWidget {
  final Widget startScreen;

  const AppWrapper({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: GetMaterialApp(
        title: 'Fitness 3 in 1',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: TColor.primaryColor1,
          fontFamily: "Poppins",
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primaryColor: TColor.primaryColor1,
          fontFamily: "Poppins",
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: startScreen, 
      ),
    );
  }
}
