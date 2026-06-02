import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  // Use Inter or default sans-serif font
  static const String fontFamily = 'Inter';

  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        letterSpacing: -0.02 * 30,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: -0.01 * 24,
        color: AppColors.onBackground,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.onBackground,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.01 * 14,
        color: AppColors.onSurface,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get buttonText => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        color: AppColors.onPrimary,
      );

  static TextTheme get textTheme => TextTheme(
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
      );
}
