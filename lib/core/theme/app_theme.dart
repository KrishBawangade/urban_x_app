import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// A class that holds the theme data for the app.
class AppTheme {
  /// The light theme for the app.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      cardColor: AppColors.card,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: TextTheme(
        headlineSmall: AppTextStyles.headline,
        titleMedium: AppTextStyles.subheadline,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.button,
      ),
      // appBarTheme: AppBarTheme(
      //   backgroundColor: AppColors.card,
      //   elevation: 0,
      //   titleTextStyle: AppTextStyles.headline.copyWith(color: AppColors.primary),
      // ),
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //   backgroundColor: AppColors.primary,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
      //   ),
      //   // To apply a gradient, you can use a custom FAB and wrap it with a ShaderMask.
      // ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: AppColors.primary,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
      //     ),
      //     textStyle: AppTextStyles.button,
      //   ),
      // ),
      // inputDecorationTheme: InputDecorationTheme(
      //   filled: true,
      //   fillColor: AppColors.card,
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
      //     borderSide: const BorderSide(color: AppColors.divider),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
      //     borderSide: const BorderSide(color: AppColors.primary),
      //   ),
      // ),
      // cardTheme: CardTheme(
      //   color: AppColors.card,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppDimens.cardRadius),
      //   ),
      //   shadowColor: Colors.black.withOpacity(0.05),
      //   elevation: 8,
      // ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.card,
        elevation: 8,
      ),
      dividerColor: AppColors.divider,
    );
  }
}