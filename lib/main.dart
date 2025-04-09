import 'package:fast_rhino/view/on_boarding/on_boarding_view.dart';
import 'package:fast_rhino/view/main_tab/main_tab_view.dart';
import 'package:fast_rhino/view/on_boarding/on_boarding_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'common/colo_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
        brightness: Brightness.light, // Light theme
      ),
      darkTheme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
        brightness: Brightness.dark, // Dark theme
      ),
      themeMode: ThemeMode.system, // Automatically switch between light and dark
      home: const OnBoardingView(),
    );
  }
}
