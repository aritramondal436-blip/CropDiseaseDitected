import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';
import 'weather_widget.dart';

/// Hero / welcome section: green gradient panel with the welcome headline
/// and "Scan Leaf" call to action plus the live weather panel.
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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.deepGreen,
            AppColors.primaryDark,
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -60,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 6,
              bottom: -54,
              child: Icon(
                Icons.eco_outlined,
                size: 150,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 520;
                  final content = _HeroContent(
                    onScanTap: () => _onScanTap(context),
                  );
                  const weather = WeatherCard();
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: content),
                        const SizedBox(width: 18),
                        const SizedBox(width: 220, child: weather),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      content,
                      const SizedBox(height: 16),
                      const SizedBox(width: double.infinity, child: weather),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({required this.onScanTap});

  final VoidCallback onScanTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 12,
                color: AppColors.accentLime,
              ),
              const SizedBox(width: 5),
              Text(
                'AI Crop Health',
                style: AppTextStyles.captionWhite.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Healthy Crops, Brighter Tomorrow',
          style: AppTextStyles.heroTitle.copyWith(fontSize: 23, height: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          'Detect crop disease with AI and protect your harvest.',
          style: AppTextStyles.bodySmallWhite.copyWith(height: 1.45),
        ),
        const SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: _ScanCtaButton(onTap: onScanTap),
        ),
      ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepGreen.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
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
            const SizedBox(width: 7),
            Text(
              'Scan Leaf',
              style: AppTextStyles.button.copyWith(
                color: AppColors.ctaGreen,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
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
