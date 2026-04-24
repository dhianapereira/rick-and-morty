import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/shared/theme/app_spacing.dart';

void main() {
  test('Should keep spacing scale ordered when layout tokens are consumed', () {
    expect(AppSpacing.xxs, lessThan(AppSpacing.sm));
    expect(AppSpacing.sm, lessThan(AppSpacing.lg));
    expect(AppSpacing.lg, lessThan(AppSpacing.xxl));
  });

  test(
    'Should expose reusable page padding when screen spacing is requested',
    () {
      expect(
        AppSpacing.pagePadding,
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      );
    },
  );
}
