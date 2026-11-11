import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';

class ProfileInfoPage extends StatelessWidget {
  const ProfileInfoPage({
    super.key,
    required this.title,
    required this.icon,
    this.message = 'This section is coming soon.',
  });

  final String title;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.agroDark,
        elevation: 0,
        title: Text(
          title,
          style: AppTextStyles.title.copyWith(
            color: AppColors.agroDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.agroPrimary, AppColors.agroFresh],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.agroPrimary.withValues(alpha: 0.28),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: AppColors.agroWhite, size: 42),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cardHeading.copyWith(
                      fontSize: 26,
                      color: AppColors.agroDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cardBody.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.agroPale,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.agroPrimary.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.eco_rounded,
                          color: AppColors.agroPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Agrovision',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.agroDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
