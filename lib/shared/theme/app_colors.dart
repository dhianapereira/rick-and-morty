import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color seed = Color(0xFFB7E529);
  static const Color primary = Color(0xFFB7E529);
  static const Color onPrimary = Color(0xFF132A13);
  static const Color primaryContainer = Color(0xFFDDF68B);
  static const Color onPrimaryContainer = Color(0xFF1D2B0E);
  static const Color secondary = Color(0xFF37D5D6);
  static const Color onSecondary = Color(0xFF062A2A);
  static const Color secondaryContainer = Color(0xFFA4F1F2);
  static const Color onSecondaryContainer = Color(0xFF0C3333);
  static const Color tertiary = Color(0xFFFFC857);
  static const Color onTertiary = Color(0xFF332100);
  static const Color tertiaryContainer = Color(0xFFFFE3A6);
  static const Color onTertiaryContainer = Color(0xFF4D3500);
  static const Color error = Color(0xFFFF6B6B);
  static const Color onError = Color(0xFF3A0505);
  static const Color errorContainer = Color(0xFFFFD6D6);
  static const Color onErrorContainer = Color(0xFF5C0F0F);
  static const Color surface = Color(0xFF0B1020);
  static const Color onSurface = Color(0xFFEAF7F7);
  static const Color surfaceDim = Color(0xFF080C18);
  static const Color surfaceBright = Color(0xFF151C31);
  static const Color surfaceContainerLowest = Color(0xFF050811);
  static const Color surfaceContainerLow = Color(0xFF10172A);
  static const Color surfaceContainer = Color(0xFF141C30);
  static const Color surfaceContainerHigh = Color(0xFF1A233B);
  static const Color surfaceContainerHighest = Color(0xFF202B45);
  static const Color onSurfaceVariant = Color(0xFFADC7C7);
  static const Color outline = Color(0xFF50757A);
  static const Color outlineVariant = Color(0xFF2E4A50);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFFEAF7F7);
  static const Color onInverseSurface = Color(0xFF111827);
  static const Color inversePrimary = Color(0xFF5D8600);

  static const Color episodeSearchBackground = Color(0xFF111A2C);
  static const Color characterHighlight = Color(0xFF8BF3FF);
  static const Color statusAlive = Color(0xFF72E08A);
  static const Color statusUnknown = Color(0xFFFFD166);
  static const Color statusDead = Color(0xFFFF7B72);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    surfaceDim: surfaceDim,
    surfaceBright: surfaceBright,
    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    shadow: shadow,
    scrim: scrim,
    inverseSurface: inverseSurface,
    onInverseSurface: onInverseSurface,
    inversePrimary: inversePrimary,
  );
}
