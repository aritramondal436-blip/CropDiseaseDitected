import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';

/// Dashboard shortcut tiles: a prominent Scan Leaf card, two compact
/// cards for My Reports and Disease Map, and a wide Expert Help card.
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PrimaryFeatureCard(
            data: _features[0],
            onTap: () => _onFeatureTap(context, _features[0].title),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SquareFeatureCard(
                  data: _features[1],
                  onTap: () => _onFeatureTap(context, _features[1].title),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SquareFeatureCard(
                  data: _features[2],
                  onTap: () => _onFeatureTap(context, _features[2].title),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _WideFeatureCard(
            data: _features[3],
            onTap: () => _onFeatureTap(context, _features[3].title),
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

class _PrimaryFeatureCard extends StatelessWidget {
  const _PrimaryFeatureCard({required this.data, required this.onTap});

  final _FeatureData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.title,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.subtitle,
                        style: AppTextStyles.bodySmallWhite.copyWith(
                          fontSize: 10.5,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primaryDark,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SquareFeatureCard extends StatelessWidget {
  const _SquareFeatureCard({required this.data, required this.onTap});

  final _FeatureData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 134,
      child: Material(
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
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: data.accent.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(data.icon, color: data.accent, size: 21),
                ),
                const SizedBox(height: 10),
                Text(
                  data.title,
                  style: AppTextStyles.title.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: Text(
                    data.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
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
      ),
    );
  }
}

class _WideFeatureCard extends StatelessWidget {
  const _WideFeatureCard({required this.data, required this.onTap});

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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: data.accent, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.title,
                      style: AppTextStyles.title.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      data.subtitle,
                      style: AppTextStyles.caption.copyWith(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: data.accent.withValues(alpha: 0.7),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
