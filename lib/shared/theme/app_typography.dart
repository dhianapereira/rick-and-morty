import 'package:flutter/material.dart';
import 'package:rickandmorty/shared/theme/app_colors.dart';

class AppTypography {
  const AppTypography._();

  static const String displayFontFamily = 'Orbitron';
  static const String bodyFontFamily = 'SpaceGrotesk';

  static const List<String> displayFontFallback = <String>[
    'Trebuchet MS',
    'Arial',
    'sans-serif',
  ];

  static const List<String> bodyFontFallback = <String>[
    'Aptos',
    'Segoe UI',
    'Roboto',
    'Arial',
    'sans-serif',
  ];

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: displayFontFamily,
      fontFamilyFallback: displayFontFallback,
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -1,
      color: AppColors.onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: displayFontFamily,
      fontFamilyFallback: displayFontFallback,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.5,
      color: AppColors.onSurface,
    ),
    headlineLarge: TextStyle(
      fontFamily: displayFontFamily,
      fontFamilyFallback: displayFontFallback,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.15,
      color: AppColors.onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: displayFontFamily,
      fontFamilyFallback: displayFontFallback,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: displayFontFamily,
      fontFamilyFallback: displayFontFallback,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: bodyFontFamily,
      fontFamilyFallback: bodyFontFallback,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: AppColors.onSurface,
    ),
    titleSmall: TextStyle(
      fontFamily: bodyFontFamily,
      fontFamilyFallback: bodyFontFallback,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: AppColors.onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: bodyFontFamily,
      fontFamilyFallback: bodyFontFallback,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: bodyFontFamily,
      fontFamilyFallback: bodyFontFallback,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.onSurface,
    ),
    bodySmall: TextStyle(
      fontFamily: bodyFontFamily,
      fontFamilyFallback: bodyFontFallback,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.onSurfaceVariant,
    ),
    labelLarge: TextStyle(
      fontFamily: bodyFontFamily,
      fontFamilyFallback: bodyFontFallback,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.1,
      color: AppColors.onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: bodyFontFamily,
      fontFamilyFallback: bodyFontFallback,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.2,
      color: AppColors.onSurface,
    ),
  );
}
