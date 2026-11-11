import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';

/// Floating bottom navigation with 4 tabs. Scanning is handled by a separate
/// floating action button on the home page.
class AgroBottomNav extends StatelessWidget {
  const AgroBottomNav({super.key, required this.currentIndex, this.onTap});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  static const List<_NavItem> _items = [
    _NavItem(label: 'Home', icon: Icons.home_rounded),
    _NavItem(label: 'Map', icon: Icons.map_rounded),
    _NavItem(label: 'Reports', icon: Icons.description_rounded),
    _NavItem(label: 'Profile', icon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepGreen.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          for (int i = 0; i < _items.length; i++)
            Expanded(child: _buildItem(context, i)),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = _items[index];
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mint : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontSize: 8.5,
                color: isSelected ? AppColors.primaryDark : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
