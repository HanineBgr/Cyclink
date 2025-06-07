
import 'package:flutter/material.dart';

class TColor {
  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);


  static List<Color> get primaryG => [ primaryColor2, primaryColor1 ];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);
static Color highIntensityColor = Color(0xFFFFB3B3); // light red
static Color mediumIntensityColor = Color(0xFFFFE0B2); // light orange
static Color lowIntensityColor = Color(0xFFB2FFB3); // light green

static Color highIntensityText = Color(0xFFD32F2F); // red
static Color mediumIntensityText = Color(0xFFF57C00); // orange
static Color lowIntensityText = Color(0xFF388E3C); // green


}