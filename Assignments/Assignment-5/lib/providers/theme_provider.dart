import 'package:flutter/material.dart';

/// Controls whether the app renders in light or dark mode.
///
/// The AppBar toggle calls [toggleTheme]; MaterialApp watches [themeMode].
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
