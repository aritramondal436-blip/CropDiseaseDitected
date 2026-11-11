import 'package:flutter/material.dart';

/// Central place for every colour used across AgroVision.
class AppColors {
  AppColors._();

  // Primary greens
  static const Color primaryDark = Color(0xFF14532D); // deep forest green
  static const Color primary = Color(0xFF1B6B34); // forest green
  static const Color secondary = Color(0xFF4CAF50); // fresh green
  static const Color secondaryLight = Color(0xFF66BB6A); // bright green
  static const Color lightGreen = Color(0xFFA5D6A7); // light green tint
  static const Color mint = Color(0xFFE7F3E9); // very light green

  // Backgrounds
  static const Color background = Color(0xFFF5F9F5); // white + light green
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFFFF8ED); // nature / cream tone

  // Feature card accents
  static const Color cardGreen = Color(0xFFE7F5E9);
  static const Color cardGreenAccent = Color(0xFF2E7D32);
  static const Color cardBlue = Color(0xFFE8F1FB);
  static const Color cardBlueAccent = Color(0xFF1976D2);
  static const Color cardYellow = Color(0xFFFFF6E1);
  static const Color cardYellowAccent = Color(0xFFF59E0B);
  static const Color cardLavender = Color(0xFFF0EBFA);
  static const Color cardLavenderAccent = Color(0xFF7C5CBF);

  // Sign-up screen
  static const Color signupGradientTop = Color(0xFFF3F9EC); // pale creamy green
  static const Color signupGradientMid = Color(0xFFCBE9C6); // soft green
  static const Color signupGradientBottom = Color(0xFF5FBE63); // deeper green
  static const Color fieldFill = Color(0xFFE7F5E9); // light green field

  // Text
  static const Color textDark = Color(0xFF1C3D2E); // dark green
  static const Color textBody = Color(0xFF4A5D6E); // blue-gray
  static const Color textMuted = Color(0xFF7A8B99);

  // CTA & alerts
  static const Color ctaGreen = Color(0xFF14662C);
  static const Color alertRed = Color(0xFFE53935);

  // Misc
  static const Color shadow = Color(0x1A2E5E2E);
  static const Color divider = Color(0xFFE3EDE5);

  // Dashboard surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0F6F1);
  static const Color outline = Color(0xFFE4EEE6);
  static const Color deepGreen = Color(0xFF0B3D24);
  static const Color accentLime = Color(0xFFB7E36B);
  static const Color skyTint = Color(0xFFEAF4EC);

  // ---------------------------------------------------------------------------
  // AgroVision registration redesign palette (crop-disease-detection theme).
  // ---------------------------------------------------------------------------

  /// Spec palette.
  static const Color agroPrimary = Color(0xFF16852B); // primary green
  static const Color agroDark = Color(0xFF064E35); // dark green
  static const Color agroFresh = Color(0xFF52B84B); // fresh green
  static const Color agroPale = Color(0xFFE8F5E9); // pale green
  static const Color agroWhite = Color(0xFFFFFFFF); // white
  static const Color agroText = Color(0xFF153D32); // text

  /// Field / scenery tones.
  static const Color fieldSkyTop = Color(0xFFEAF6D8); // warm morning light
  static const Color fieldSkyMid = Color(0xFFBEE29A); // sunlit haze
  static const Color fieldSunGlow = Color(0xFFFFF3C4); // warm sunlight
  static const Color fieldCanopy = Color(0xFF2E7D32); // mid crop green
  static const Color fieldDeep = Color(0xFF0B4D2C); // shadowed rows

  /// Layered bottom hills.
  static const Color hillBack = Color(0xFF0B6B3A);
  static const Color hillMid = Color(0xFF0A5A32);
  static const Color hillFront = Color(0xFF084C2B);

  /// AI scanner highlights.
  static const Color scanGlow = Color(0xFF39FF88); // neon green
  static const Color scanSpot = Color(0xFF7A4A22); // diseased leaf spot

  /// Glass surfaces.
  static const Color glassFill = Color(0xCCFFFFFF); // translucent white
  static const Color glassTint = Color(0xFFE8F5E9); // pale green tint
  static const Color glassBorder = Color(0x99FFFFFF); // subtle white border
  static const Color glassShadow = Color(0x33064E35);
}
