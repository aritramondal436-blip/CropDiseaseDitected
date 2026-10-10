import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'ai_insights.dart';
import 'bottom_nav.dart';
import 'feature_cards.dart';
import 'hero_section.dart';
import 'popular_cart.dart';
import 'top_header.dart';

/// Main AgroVision home page composed of scrollable sections
/// and a custom bottom navigation bar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    if (index == 0) {
      setState(() => _selectedIndex = 0);
      return;
    }
    const labels = {
      1: 'Opening leaf scanner…',
      2: 'Disease map coming soon',
      3: 'Reports coming soon',
      4: 'Profile coming soon',
    };
    final label = labels[index] ?? 'Coming soon';
    setState(() => _selectedIndex = index);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(label)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TopHeader(),
                    SizedBox(height: 14),
                    HeroSection(),
                    SizedBox(height: 24),
                    FeatureCards(),
                    SizedBox(height: 24),
                    AIInsights(),
                    SizedBox(height: 24),
                    PopularCrops(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: AgroBottomNav(
                currentIndex: _selectedIndex,
                onTap: _onNavTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
