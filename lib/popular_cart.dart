import 'package:flutter/material.dart';

import 'all_crops_page.dart';
import 'app_colours.dart';
import 'app_text_styles.dart';
import 'crop_data.dart';
import 'crop_details_page.dart';

/// "Popular Crops" section with a View All action and a horizontal
/// scrollable list of crop cards. Tapping a crop opens its details page.
class PopularCrops extends StatelessWidget {
  const PopularCrops({super.key});

  static const List<Color> _backgrounds = [
    AppColors.cardGreen,
    AppColors.cardYellow,
    AppColors.cardLavender,
    AppColors.cardBlue,
    AppColors.mint,
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AllCropsPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primaryDark,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primaryDark,
                        size: 13,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 134,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: cropCatalog.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final crop = cropCatalog[index];
              return _CropCard(
                name: crop.name,
                emoji: crop.emoji,
                diseaseCount: crop.diseases.length,
                bg: _backgrounds[index % _backgrounds.length],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CropDetailsPage(crop: crop),
                    ),
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

class _CropCard extends StatelessWidget {
  const _CropCard({
    required this.name,
    required this.emoji,
    required this.diseaseCount,
    required this.bg,
    required this.onTap,
  });

  final String name;
  final String emoji;
  final int diseaseCount;
  final Color bg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 27)),
                ),
                const Spacer(),
                Text(
                  name,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  diseaseCount == 0
                      ? 'No records yet'
                      : '$diseaseCount diseases',
                  style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
