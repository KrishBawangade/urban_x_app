import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// A class that holds all the text style values for the app.
class AppTextStyles {
  static final TextStyle _baseTextStyle = GoogleFonts.poppins();

  /// The text style for headlines.
  static TextStyle get headline => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  /// The text style for sub-headlines.
  static TextStyle get subheadline => _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  /// The text style for body text.
  static TextStyle get body => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  /// The text style for captions.
  static TextStyle get caption => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  /// The text style for buttons.
  static TextStyle get button => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.card,
      );
}
