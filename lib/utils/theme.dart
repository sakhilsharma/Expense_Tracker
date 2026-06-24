import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme =
  ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor:
    const Color(0xFFF8F9FD),
    cardColor:
    Colors.white,
    colorScheme:
    ColorScheme.fromSeed(
      seedColor:
      const Color(0xFF6C63FF),
      brightness:
      Brightness.light,
    ),
  );

  static final darkTheme =
  ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor:
    const Color(0xFF0F0E17),
    cardColor:
    const Color(0xFF1E1E2E),
    colorScheme:
    ColorScheme.fromSeed(
      seedColor:
      const Color(0xFF6C63FF),
      brightness:
      Brightness.dark,
    ),
  );
}