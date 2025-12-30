import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;

  const AppSearchBar({
    super.key,
    this.hintText = 'Search',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onSurface.withValues(alpha: 0.6),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hintText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
