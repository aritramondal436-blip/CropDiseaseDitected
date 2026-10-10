import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';

/// Wide "AI-Powered Insights" card highlighting how the app uses
/// neural networks and computer vision to detect crop diseases and
/// predict potential outbreaks.
class AIInsights extends StatelessWidget {
  const AIInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'AI-Powered Insights',
                        style: AppTextStyles.titleWhite,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Neural networks and computer vision detect crop '
                  'diseases in seconds and help predict potential '
                  'outbreaks in your area.',
                  style: AppTextStyles.bodyWhite,
                ),
                const SizedBox(height: 14),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InsightPill(
                      icon: Icons.hub_rounded,
                      label: 'Neural Networks',
                    ),
                    _InsightPill(
                      icon: Icons.remove_red_eye_rounded,
                      label: 'Computer Vision',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const _NeuralVisual(),
        ],
      ),
    );
  }
}

class _InsightPill extends StatelessWidget {
  const _InsightPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.bodyWhite.copyWith(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder illustration of a neural network being scanned, framed by
/// detection corner brackets.
class _NeuralVisual extends StatelessWidget {
  const _NeuralVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.hub_rounded, color: Colors.white, size: 40),
          const _CornerBracket(side: _BracketSide.topLeft),
          const _CornerBracket(side: _BracketSide.topRight),
          const _CornerBracket(side: _BracketSide.bottomLeft),
          const _CornerBracket(side: _BracketSide.bottomRight),
        ],
      ),
    );
  }
}

enum _BracketSide { topLeft, topRight, bottomLeft, bottomRight }

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({required this.side});

  final _BracketSide side;

  static const double _inset = 8;
  static const double _size = 12;
  static const double _stroke = 2;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withValues(alpha: 0.85);
    final side1 = BorderSide(color: color, width: _stroke);
    final side2 = BorderSide(color: color, width: _stroke);
    const radius = BorderRadius.all(Radius.circular(4));

    final Border border;
    final BorderRadius borderRadius;

    switch (side) {
      case _BracketSide.topLeft:
        border = Border(top: side1, left: side2);
        borderRadius = radius;
      case _BracketSide.topRight:
        border = Border(top: side1, right: side2);
        borderRadius = radius;
      case _BracketSide.bottomLeft:
        border = Border(bottom: side1, left: side2);
        borderRadius = radius;
      case _BracketSide.bottomRight:
        border = Border(bottom: side1, right: side2);
        borderRadius = radius;
    }

    return Positioned(
      top: side == _BracketSide.topLeft || side == _BracketSide.topRight
          ? _inset
          : null,
      bottom:
          side == _BracketSide.bottomLeft || side == _BracketSide.bottomRight
          ? _inset
          : null,
      left: side == _BracketSide.topLeft || side == _BracketSide.bottomLeft
          ? _inset
          : null,
      right: side == _BracketSide.topRight || side == _BracketSide.bottomRight
          ? _inset
          : null,
      child: IgnorePointer(
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(border: border, borderRadius: borderRadius),
        ),
      ),
    );
  }
}
