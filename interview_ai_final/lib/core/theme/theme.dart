import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        surfaceTint: AppColors.surfaceTint,
        inversePrimary: AppColors.inversePrimary,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
      ),

      textTheme: AppTypography.textTheme,

      // Default AppBar Style following Material 3 guidelines
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceContainerLowest,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 2.0,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.onBackground,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),

      // Default ElevatedButton Style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.onSurface.withOpacity(0.12),
          disabledForegroundColor: AppColors.onSurface.withOpacity(0.38),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Default OutlinedButton Style
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outlineVariant, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          textStyle: AppTypography.buttonText.copyWith(color: AppColors.primary),
        ),
      ),

      // Default TextButton Style
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          textStyle: AppTypography.buttonText.copyWith(
            color: AppColors.primary,
            fontSize: 14,
          ),
        ),
      ),

      // Default Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.3),
            width: 1.0,
          ),
        ),
      ),

      // Default Input Decoration Theme for TextFields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.6)),
        errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error, fontSize: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.inversePrimary,
      scaffoldBackgroundColor: AppColors.inverseSurface,
      
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.inversePrimary,
        onPrimary: AppColors.inverseOnSurface,
        primaryContainer: AppColors.primary,
        onPrimaryContainer: AppColors.onPrimary,
        secondary: AppColors.secondaryContainer,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondary,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiaryContainer,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiary,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.inverseSurface,
        onSurface: AppColors.inverseOnSurface,
        onSurfaceVariant: AppColors.outlineVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        surfaceTint: AppColors.surfaceTint,
        inversePrimary: AppColors.primary,
        inverseSurface: AppColors.surface,
        onInverseSurface: AppColors.onSurface,
      ),

      textTheme: AppTypography.textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.inverseSurface,
        foregroundColor: AppColors.inverseOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.inverseOnSurface,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.inversePrimary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.inversePrimary,
          foregroundColor: AppColors.inverseOnSurface,
          disabledBackgroundColor: AppColors.inverseOnSurface.withOpacity(0.12),
          disabledForegroundColor: AppColors.inverseOnSurface.withOpacity(0.38),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          textStyle: AppTypography.buttonText.copyWith(color: AppColors.inverseOnSurface),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inversePrimary,
          side: const BorderSide(color: AppColors.outline, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          textStyle: AppTypography.buttonText.copyWith(color: AppColors.inversePrimary),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.inversePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          textStyle: AppTypography.buttonText.copyWith(
            color: AppColors.inversePrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
