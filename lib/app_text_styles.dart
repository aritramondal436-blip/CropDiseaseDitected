import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colours.dart';

/// Typography helpers based on the Poppins family.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get display => GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.25,
  );

  static TextStyle get title => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle get titleWhite => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get sectionTitle => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle get body => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textBody,
    height: 1.5,
  );

  static TextStyle get bodyWhite => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.5,
  );

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextStyle get label => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // White-on-gradient variants for the hero and AI insight panels.
  static TextStyle get heroTitle => GoogleFonts.poppins(
    fontSize: 21,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.25,
  );

  static TextStyle get bodySmallWhite => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.5,
  );

  static TextStyle get captionWhite => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    height: 1.2,
  );

  static TextStyle get statWhite => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  // Dashboard helpers.
  static TextStyle get greeting => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.2,
  );

  static TextStyle get microLabel => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
  );

  static TextStyle get cardTitle => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle get statValue => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.2,
  );

  // Registration redesign helpers.

  /// Bold dark-green heading used on the glass card.
  static TextStyle get cardHeading => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.agroText,
    height: 1.2,
  );

  /// Muted supporting copy on the glass card.
  static TextStyle get cardBody => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.agroText.withValues(alpha: 0.72),
    height: 1.5,
  );

  /// Hover/tap handwriting-style tagline.
  static TextStyle get handwritten => GoogleFonts.caveat(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.agroWhite,
    height: 1.1,
  );
}
