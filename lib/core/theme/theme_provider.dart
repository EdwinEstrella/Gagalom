// Theme Provider - Centralized Theme Management
// This file is prepared for theme switching implementation
//
// All colors are already centralized in AppColors class
// When ready to implement theme switching, follow these steps:
//
// STEP 1: Uncomment and use this provider in main.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final themeModeProvider = StateProvider<ThemeMode>((ref) {
//   return ThemeMode.system; // Default to system theme
// });
//
// STEP 2: Update main.dart to use the provider:
//
// class MyApp extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeModeProvider);
//     return MaterialApp(
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: themeMode,
//       home: const MainScreen(),
//     );
//   }
// }
//
// STEP 3: Update settings_screen.dart Switch onChanged:
//
// onChanged: (value) {
//   ref.read(themeModeProvider.notifier).state =
//     value ? ThemeMode.dark : ThemeMode.light;
// },
//
// OPTIONAL STEP 4: Add persistence with shared_preferences
//
// final themeModeProvider = StateProvider<ThemeMode>((ref) {
//   final prefs = ref.watch(sharedPreferencesProvider);
//   final isDarkMode = prefs.getBool('isDarkMode') ?? false;
//   return isDarkMode ? ThemeMode.dark : ThemeMode.light;
// });
//
// And save when toggling:
// final prefs = await SharedPreferences.getInstance();
// await prefs.setBool('isDarkMode', value);

