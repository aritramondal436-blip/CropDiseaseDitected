import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';

/// "Popular Crops" section with a View All action and a horizontal
/// scrollable list of crop cards.
class PopularCrops extends StatelessWidget {
  const PopularCrops({super.key});

  static const List<_CropData> _crops = [
    _CropData(name: 'Tomato', emoji: '🍅', bg: AppColors.cardGreen),
    _CropData(name: 'Potato', emoji: '🥔', bg: AppColors.cardYellow),
    _CropData(name: 'Corn', emoji: '🌽', bg: AppColors.cardLavender),
    _CropData(name: 'Rice', emoji: '🌾', bg: AppColors.cardBlue),
    _CropData(name: 'Wheat', emoji: '🌱', bg: AppColors.mint),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Popular Crops',
                  style: AppTextStyles.sectionTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('All crops coming soon')),
                    );
                },
                child: Text(
                  'View All',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _crops.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final crop = _crops[index];
              return _CropCard(
                crop: crop,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text('${crop.name} scans coming soon')),
                    );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CropData {
  const _CropData({required this.name, required this.emoji, required this.bg});

  final String name;
  final String emoji;
  final Color bg;
}

class _CropCard extends StatelessWidget {
  const _CropCard({required this.crop, required this.onTap});

  final _CropData crop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: crop.bg,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(crop.emoji, style: const TextStyle(fontSize: 28)),
            ),
            Text(crop.name, style: AppTextStyles.label),
          ],
        ),
      ),
    );
  }
}
