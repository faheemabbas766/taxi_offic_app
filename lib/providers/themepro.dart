import 'package:flutter/material.dart';

class ThemeModeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppColors {
  final ThemeData themeData;
  final ThemeMode themeMode;

  AppColors(this.themeData, this.themeMode);
  Color get primaryColor => themeMode == ThemeMode.light ? Colors.black : Colors.white;
  Color get secondaryColor => themeMode == ThemeMode.light ? Colors.white : Colors.black;
  Color get primaryDimColor => themeMode == ThemeMode.light ? Colors.blueGrey : Colors.white70;
  Color get secondaryDimColor => themeMode == ThemeMode.light ? Colors.white70 : Colors.black12;
  Color get accentColor =>  Colors.amber;

  // Static method to provide AppColors instance based on BuildContext
  static AppColors of(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = Theme.of(context).brightness == Brightness.light
        ? ThemeMode.light
        : ThemeMode.dark;
    return AppColors(theme, themeMode);
  }
}
