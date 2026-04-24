import 'package:flutter/foundation.dart';
import 'package:rickandmorty/application/theme/app_theme_preference.dart';
import 'package:rickandmorty/application/theme/theme_local_data_source.dart';

class ThemeController extends ValueNotifier<AppThemePreference> {
  ThemeController({required ThemeLocalDataSource localDataSource})
    : _localDataSource = localDataSource,
      super(AppThemePreference.system);

  final ThemeLocalDataSource _localDataSource;

  Future<void> loadThemePreference() async {
    final String? storedValue = await _localDataSource.fetchThemePreference();
    value = AppThemePreference.fromStorageValue(storedValue);
  }

  Future<void> updateThemePreference(AppThemePreference preference) async {
    if (value == preference) {
      return;
    }

    value = preference;
    await _localDataSource.saveThemePreference(preference.storageValue);
  }
}
