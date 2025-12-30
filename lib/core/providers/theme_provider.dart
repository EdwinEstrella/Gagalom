import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeMode { light, dark, system }

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_getLightTheme());

  static ThemeData _getLightTheme() {
    // Import from your app_theme.dart
    return ThemeData.light();
  }

  void toggleTheme() {
    if (state.brightness == Brightness.light) {
      state = ThemeData.dark();
    } else {
      state = ThemeData.light();
    }
  }

  void setTheme(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        state = ThemeData.light();
        break;
      case ThemeMode.dark:
        state = ThemeData.dark();
        break;
      case ThemeMode.system:
        // Could use MediaQuery.platformBrightnessOf
        state = ThemeData.light();
        break;
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
