import 'package:fast_rhino/view/Splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common/colo_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      home: SplashScreen(), 
    );
  }
}