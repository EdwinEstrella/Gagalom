import 'package:flutter/material.dart';

// App routes - will be expanded as we add more screens
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String product = '/product';
  static const String cart = '/cart';
  static const String profile = '/profile';
}

// Simple navigation helper
class NavigationHelper {
  static void pushTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  static void pushToAndClear(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
