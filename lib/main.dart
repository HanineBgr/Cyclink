import 'package:fast_rhino/providers/workout_provider.dart';
import 'package:fast_rhino/view/Splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'common/colo_extension.dart';
import 'providers/auth_provider.dart';
import 'view/main_tab/main_tab_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();
  Widget _initialScreen = const SplashScreen();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    String? token = await storage.read(key: 'jwt_token');
    if (token != null) {
      setState(() {
        _initialScreen = const MainTabView();
      });
    }
  }

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
        home: _initialScreen,
      ),
    );
  }
}
