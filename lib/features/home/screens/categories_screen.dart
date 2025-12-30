import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/icons/arrow-left.svg',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Comprar por Categorías',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Categories List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildCategoryItem(
                    context,
                    icon: Icons.checkroom_outlined,
                    name: 'Sudaderas',
                    onTap: () {
                      // Navigate to hoodies products
                    },
                  ),
                  _buildCategoryItem(
                    context,
                    icon: Icons.diamond_outlined,
                    name: 'Accesorios',
                    onTap: () {
                      // Navigate to accessories products
                    },
                  ),
                  _buildCategoryItem(
                    context,
                    icon: Icons.shortcut_outlined,
                    name: 'Shorts',
                    onTap: () {
                      // Navigate to shorts products
                    },
                  ),
                  _buildCategoryItem(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    name: 'Zapatos',
                    onTap: () {
                      // Navigate to shoes products
                    },
                  ),
                  _buildCategoryItem(
                    context,
                    icon: Icons.work_outline,
                    name: 'Bolsos',
                    onTap: () {
                      // Navigate to bags products
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required IconData icon,
    required String name,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 16),
            // Name
            Expanded(
              child: Text(
                name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
