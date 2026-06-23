//add themes before hand --> pure app me same idea raheaga..
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff0F172A),

    colorScheme: ColorScheme.dark(
      primary: Color(0xff22C55E),
    ),

    cardColor: const Color(0xff1E293B),
  );
}