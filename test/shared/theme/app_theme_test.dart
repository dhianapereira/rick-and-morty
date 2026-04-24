import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/shared/theme/app_colors.dart';
import 'package:rickandmorty/shared/theme/app_spacing.dart';
import 'package:rickandmorty/shared/theme/app_theme.dart';
import 'package:rickandmorty/shared/theme/app_typography.dart';

void main() {
  test('Should configure light theme when light theme is accessed', () {
    final ThemeData theme = AppTheme.light;

    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.onSurface, AppColors.lightOnSurface);
    expect(
      theme.textTheme.displayLarge?.fontFamily,
      AppTypography.displayFontFamily,
    );
    expect(theme.textTheme.bodyLarge?.fontFamily, AppTypography.bodyFontFamily);
    expect(theme.textTheme.bodySmall?.color, AppColors.lightOnSurfaceVariant);
  });

  test(
    'Should configure dark theme from shared tokens when dark theme is accessed',
    () {
      final ThemeData theme = AppTheme.dark;

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme, AppColors.lightColorScheme);
      expect(theme.scaffoldBackgroundColor, AppColors.surface);
    },
  );

  test(
    'Should reuse shared spacing in input decoration when theme is accessed',
    () {
      final ThemeData theme = AppTheme.light;

      expect(theme.inputDecorationTheme.contentPadding, AppSpacing.cardPadding);
    },
  );
}
