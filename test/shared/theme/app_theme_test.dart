import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/shared/theme/app_colors.dart';
import 'package:rickandmorty/shared/theme/app_spacing.dart';
import 'package:rickandmorty/shared/theme/app_theme.dart';
import 'package:rickandmorty/shared/theme/app_typography.dart';

void main() {
  test(
    'Should configure theme from shared tokens when light theme is accessed',
    () {
      final ThemeData theme = AppTheme.light;

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme, AppColors.lightColorScheme);
      expect(theme.scaffoldBackgroundColor, AppColors.surface);
      expect(
        theme.textTheme.displayLarge?.fontFamily,
        AppTypography.displayFontFamily,
      );
      expect(
        theme.textTheme.bodyLarge?.fontFamily,
        AppTypography.bodyFontFamily,
      );
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
