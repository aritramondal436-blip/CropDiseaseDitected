import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';

/// 2x2 grid of feature shortcuts: Scan Leaf, My Reports,
/// Disease Map and Expert Help.
class FeatureCards extends StatelessWidget {
  const FeatureCards({super.key});

  static const List<_FeatureData> _features = [
    _FeatureData(
      title: 'Scan Leaf',
      subtitle: 'Take a photo or upload an image of the leaf',
      icon: Icons.qr_code_scanner_rounded,
      bg: AppColors.cardGreen,
      accent: AppColors.cardGreenAccent,
    ),
    _FeatureData(
      title: 'My Reports',
      subtitle: 'View your past detections and analysis',
      icon: Icons.description_rounded,
      bg: AppColors.cardBlue,
      accent: AppColors.cardBlueAccent,
    ),
    _FeatureData(
      title: 'Disease Map',
      subtitle: 'Check disease spread in your area',
      icon: Icons.map_rounded,
      bg: AppColors.cardYellow,
      accent: AppColors.cardYellowAccent,
    ),
    _FeatureData(
      title: 'Expert Help',
      subtitle: 'Connect with agricultural experts and get guidance',
      icon: Icons.support_agent_rounded,
      bg: AppColors.cardLavender,
      accent: AppColors.cardLavenderAccent,
    ),
  ];

  void _onFeatureTap(BuildContext context, String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$name coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
        children: [
          for (final feature in _features)
            _FeatureCard(
              data: feature,
              onTap: () => _onFeatureTap(context, feature.title),
            ),
        ],
      ),
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bg,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color bg;
  final Color accent;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.data, required this.onTap});

  final _FeatureData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: data.bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: data.accent.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(data.icon, color: data.accent, size: 22),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: data.accent.withValues(alpha: 0.7),
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                data.title,
                style: AppTextStyles.title.copyWith(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Expanded(
                child: Text(
                  data.subtitle,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10.5,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
