import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';

/// Custom bottom navigation with 5 tabs; the middle "Scan" tab is
/// raised as a green circular action button.
class AgroBottomNav extends StatelessWidget {
  const AgroBottomNav({super.key, required this.currentIndex, this.onTap});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const List<_NavItem> _items = [
    _NavItem(label: 'Home', icon: Icons.home_rounded),
    _NavItem(label: 'Scan', icon: Icons.qr_code_scanner_rounded),
    _NavItem(label: 'Map', icon: Icons.map_rounded),
    _NavItem(label: 'Reports', icon: Icons.description_rounded),
    _NavItem(label: 'Profile', icon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < _items.length; i++) _buildItem(context, i),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = _items[index];
    final bool isMiddle = index == 1;
    final bool isSelected = currentIndex == index;

    if (isMiddle) {
      return GestureDetector(
        onTap: () => onTap?.call(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: isSelected
                  ? AppTextStyles.caption.copyWith(color: AppColors.secondary)
                  : AppTextStyles.caption,
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            color: isSelected ? AppColors.secondary : AppColors.textMuted,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: isSelected
                ? AppTextStyles.caption.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  )
                : AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
