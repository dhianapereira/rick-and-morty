import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/shared/theme/app_colors.dart';
import 'package:rickandmorty/shared/theme/app_typography.dart';

void main() {
  test(
    'Should use display font family when prominent titles are requested',
    () {
      expect(
        AppTypography.textTheme.displayLarge?.fontFamily,
        AppTypography.displayFontFamily,
      );
      expect(
        AppTypography.textTheme.headlineMedium?.fontFamily,
        AppTypography.displayFontFamily,
      );
    },
  );

  test(
    'Should use body font family when readable content styles are requested',
    () {
      expect(
        AppTypography.textTheme.bodyLarge?.fontFamily,
        AppTypography.bodyFontFamily,
      );
      expect(
        AppTypography.textTheme.bodySmall?.color,
        AppColors.onSurfaceVariant,
      );
    },
  );
}
