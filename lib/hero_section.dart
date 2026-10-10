import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';
import 'weather_widget.dart';

/// Hero / welcome section: green gradient panel with the welcome headline
/// and "Scan Leaf" call to action on the left, and the live weather plus
/// AI detection status panel on the right.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  void _onScanTap(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Opening leaf scanner…')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -14,
            top: -10,
            child: Icon(
              Icons.eco_outlined,
              size: 150,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Healthy Crops, Brighter Tomorrow',
                      style: AppTextStyles.heroTitle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Detect crop disease with AI and protect your harvest.',
                      style: AppTextStyles.bodySmallWhite,
                    ),
                    const SizedBox(height: 18),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: _ScanCtaButton(onTap: () => _onScanTap(context)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const WeatherCard(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScanCtaButton extends StatelessWidget {
  const _ScanCtaButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_camera_rounded,
              color: AppColors.ctaGreen,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Scan Leaf',
              style: AppTextStyles.button.copyWith(
                color: AppColors.ctaGreen,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.ctaGreen,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
