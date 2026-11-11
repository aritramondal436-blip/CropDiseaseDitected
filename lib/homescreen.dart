import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'ai_insights.dart';
import 'bottom_nav.dart';
import 'feature_cards.dart';
import 'hero_section.dart';
import 'popular_cart.dart';
import 'profile_screen.dart';
import 'top_header.dart';

/// Main AgroVision home page composed of scrollable sections
/// and a custom floating bottom navigation bar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    if (index == 0 || index == 3) {
      setState(() => _selectedIndex = index);
      return;
    }
    const labels = {
      1: 'Disease map coming soon',
      2: 'Reports coming soon',
    };
    final label = labels[index] ?? 'Coming soon';
    setState(() => _selectedIndex = index);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(label)));
  }

  void _onScanTap() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Opening leaf scanner…')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.skyTint, AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                children: [
                  Expanded(
                    child: _selectedIndex == 3
                        ? const ProfileScreen()
                        : SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 96),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TopHeader(
                                  onProfileTap: () =>
                                      setState(() => _selectedIndex = 3),
                                ),
                                const SizedBox(height: 12),
                                const HeroSection(),
                                const SizedBox(height: 22),
                                const FeatureCards(),
                                const SizedBox(height: 22),
                                const AIInsights(),
                                const SizedBox(height: 22),
                                const PopularCrops(),
                              ],
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AgroBottomNav(
                          currentIndex: _selectedIndex,
                          onTap: _onNavTap,
                        ),
                        Positioned(
                          top: -46,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _ScanFab(onTap: _onScanTap),
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

class _ScanFab extends StatelessWidget {
  const _ScanFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryDark, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
