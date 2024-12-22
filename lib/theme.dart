import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Define your color schemes
  static final lightTheme = FlexThemeData.light(
    scheme: FlexScheme.deepBlue,
  );

  static final darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.deepBlue,
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
