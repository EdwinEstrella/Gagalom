import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/app_tab_bar.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/profile/screens/settings_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentTabIndex = 0;

  // Lista de pantallas que se mantienen en memoria usando IndexedStack
  final List<Widget> _screens = [
    const HomeScreen(),
    const NotificationsScreen(),
    const OrdersScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppTabBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }
}
