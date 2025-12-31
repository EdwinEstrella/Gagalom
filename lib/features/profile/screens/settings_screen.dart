import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),

              const SizedBox(height: 32),

              // User Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Gilbert Jones',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gilbertjones001@gmail.com',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '121-224-7890',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to edit profile (can be expanded later)
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Theme Toggle
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.brightness_6_outlined,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                         ref.read(themeProvider.notifier).setTheme(
                           value ? ThemeMode.dark : ThemeMode.light
                         );
                      },
                      activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                      activeThumbColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Menu Options
              _buildMenuItem(
                context,
                icon: Icons.location_on_outlined,
                title: 'Address',
                onTap: () {
                  // Navigate to address screen (can be expanded later)
                },
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                context,
                icon: Icons.favorite_outline,
                title: 'Wishlist',
                onTap: () {
                  // Navigate to wishlist screen (can be expanded later)
                },
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                context,
                icon: Icons.payment_outlined,
                title: 'Payment',
                onTap: () {
                  // Navigate to payment screen (can be expanded later)
                },
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                context,
                icon: Icons.help_outline,
                title: 'Help',
                onTap: () {
                  // Navigate to help screen (can be expanded later)
                },
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                context,
                icon: Icons.support_agent_outlined,
                title: 'Support',
                onTap: () {
                  // Navigate to support screen (can be expanded later)
                },
              ),

              const SizedBox(height: 32),

              // Sign Out Button
              GestureDetector(
                onTap: () {
                  _showSignOutDialog(context);
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFA3636),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurface),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Sign out logic (can be expanded later)
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Color(0xFFFA3636)),
              ),
            ),
          ],
        );
      },
    );
  }
}
