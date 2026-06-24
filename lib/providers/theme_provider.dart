import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  Future<void> loadTheme() async {
    final box =
    await Hive.openBox(
      'settings',
    );

    _isDark =
        box.get(
          'isDark',
          defaultValue: false,
        );

    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDark = value;

    final box =
    await Hive.openBox(
      'settings',
    );

    await box.put(
      'isDark',
      value,
    );

    notifyListeners();
  }
}

//////--------? flow
/*
* Switch
    ↓
toggleTheme(true)
    ↓
Hive.put()
    ↓
notifyListeners()
    ↓
MaterialApp rebuilds
* */