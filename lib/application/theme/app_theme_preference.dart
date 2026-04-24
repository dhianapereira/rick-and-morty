import 'package:flutter/material.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';

enum AppThemePreference {
  system(
    storageValue: 'system',
    themeMode: ThemeMode.system,
    icon: Icons.brightness_auto_rounded,
  ),
  light(
    storageValue: 'light',
    themeMode: ThemeMode.light,
    icon: Icons.light_mode_rounded,
  ),
  dark(
    storageValue: 'dark',
    themeMode: ThemeMode.dark,
    icon: Icons.dark_mode_rounded,
  );

  const AppThemePreference({
    required this.storageValue,
    required this.themeMode,
    required this.icon,
  });

  final String storageValue;
  final ThemeMode themeMode;
  final IconData icon;

  String label(AppLocalizations l10n) {
    return switch (this) {
      AppThemePreference.system => l10n.themeSystemLabel,
      AppThemePreference.light => l10n.themeLightLabel,
      AppThemePreference.dark => l10n.themeDarkLabel,
    };
  }

  static AppThemePreference fromStorageValue(String? value) {
    return AppThemePreference.values.firstWhere(
      (AppThemePreference preference) => preference.storageValue == value,
      orElse: () => AppThemePreference.system,
    );
  }
}
