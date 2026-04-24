import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/shared/theme/app_colors.dart';

void main() {
  test(
    'Should expose a dark catalog color scheme when palette is requested',
    () {
      expect(AppColors.lightColorScheme.brightness, Brightness.dark);
      expect(AppColors.lightColorScheme.primary, AppColors.primary);
      expect(AppColors.lightColorScheme.secondary, AppColors.secondary);
      expect(AppColors.lightColorScheme.surface, AppColors.surface);
    },
  );

  test(
    'Should provide semantic status colors when domain accents are needed',
    () {
      expect(AppColors.statusAlive, const Color(0xFF72E08A));
      expect(AppColors.statusUnknown, const Color(0xFFFFD166));
      expect(AppColors.statusDead, const Color(0xFFFF7B72));
    },
  );
}
