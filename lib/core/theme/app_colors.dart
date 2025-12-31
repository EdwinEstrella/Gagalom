import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors (from Figma design)
  static const Color lightBackground = Color(0xFFF5F5F5); // Light gray background
  static const Color lightSurface = Color(0xFFFFFFFF); // White cards
  static const Color lightPrimary = Color(0xFF8A2BE2); // Violet/purple buttons
  static const Color lightSecondary = Color(0xFFFFC107); // Yellow accent
  static const Color lightAccent = Color(0xFF8A2BE2); // Same as primary
  static const Color lightError = Color(0xFFB00020);
  static const Color lightOnPrimary = Color(0xFFFFFFFF); // White text on buttons
  static const Color lightOnSurface = Color(0xFF212121); // Dark gray text
  static const Color lightOutline = Color(0xFFE0E0E0); // Light gray borders

  // Dark Theme Colors (inverted for dark mode)
  static const Color darkBackground = Color(0xFF121212); // Very dark background
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark gray cards
  static const Color darkPrimary = Color(0xFF9D4CED); // Lighter violet for dark mode
  static const Color darkSecondary = Color(0xFFFFD54F); // Lighter yellow
  static const Color darkAccent = Color(0xFF9D4CED); // Same as primary
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = Color(0xFFFFFFFF); // White text on buttons
  static const Color darkOnSurface = Color(0xFFFFFFFF); // White text
  static const Color darkOutline = Color(0xFF333333); // Dark gray borders

  // Common Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF212121);
  static const Color transparent = Colors.transparent;

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
}
