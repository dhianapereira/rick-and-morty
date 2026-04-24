import 'package:flutter/material.dart';
import 'package:rickandmorty/shared/theme/app_colors.dart';
import 'package:rickandmorty/shared/theme/app_spacing.dart';
import 'package:rickandmorty/shared/theme/app_typography.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightOnSurface,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      outline: AppColors.lightOutline,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    canvasColor: AppColors.lightBackground,
    splashFactory: InkRipple.splashFactory,
    textTheme: AppTypography.textTheme
        .apply(
          bodyColor: AppColors.lightOnSurface,
          displayColor: AppColors.lightOnSurface,
        )
        .copyWith(
          bodySmall: AppTypography.textTheme.bodySmall?.copyWith(
            color: AppColors.lightOnSurfaceVariant,
          ),
          labelLarge: AppTypography.textTheme.labelLarge?.copyWith(
            color: AppColors.lightOnSurface,
          ),
          labelMedium: AppTypography.textTheme.labelMedium?.copyWith(
            color: AppColors.lightOnSurface,
          ),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightOnSurface,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: AppTypography.displayFontFamily,
        fontFamilyFallback: AppTypography.displayFontFallback,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.lightOnSurface,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceContainer,
      contentPadding: AppSpacing.cardPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.lightOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.lightOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.lightOnSurfaceVariant,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 1,
      shadowColor: AppColors.shadow.withValues(alpha: 0.08),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurfaceContainer,
      disabledColor: AppColors.lightSurfaceContainerHigh,
      selectedColor: AppColors.primaryContainer,
      secondarySelectedColor: AppColors.secondaryContainer,
      padding: AppSpacing.chipPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      labelStyle: AppTypography.textTheme.labelMedium!,
      secondaryLabelStyle: AppTypography.textTheme.labelMedium!,
      brightness: Brightness.light,
      side: BorderSide.none,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightSurfaceContainerHigh,
      thickness: 1,
      space: AppSpacing.lg,
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: AppColors.surface,
    canvasColor: AppColors.surface,
    splashFactory: InkRipple.splashFactory,
    textTheme: AppTypography.textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: AppTypography.displayFontFamily,
        fontFamilyFallback: AppTypography.displayFontFallback,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.episodeSearchBackground,
      contentPadding: AppSpacing.cardPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainer,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      disabledColor: AppColors.surfaceContainerLow,
      selectedColor: AppColors.primaryContainer,
      secondarySelectedColor: AppColors.secondaryContainer,
      padding: AppSpacing.chipPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      labelStyle: AppTypography.textTheme.labelMedium!,
      secondaryLabelStyle: AppTypography.textTheme.labelMedium!,
      brightness: Brightness.dark,
      side: BorderSide.none,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariant,
      thickness: 1,
      space: AppSpacing.lg,
    ),
  );
}
