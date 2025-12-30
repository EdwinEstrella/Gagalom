import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTabBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTabItem(
                context: context,
                icon: 'assets/icons/home.svg',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _buildTabItem(
                context: context,
                icon: 'assets/icons/notification.svg',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _buildTabItem(
                context: context,
                icon: 'assets/icons/receipt.svg',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _buildTabItem(
                context: context,
                icon: 'assets/icons/profile.svg',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
