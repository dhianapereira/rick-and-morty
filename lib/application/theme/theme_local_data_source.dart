import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ThemeLocalDataSource {
  Future<String?> fetchThemePreference();
  Future<void> saveThemePreference(String value);
}

class SharedPreferencesThemeLocalDataSource implements ThemeLocalDataSource {
  SharedPreferencesThemeLocalDataSource({
    required SharedPreferencesAsync preferences,
  }) : _preferences = preferences;

  final SharedPreferencesAsync _preferences;

  static const String _themePreferenceKey = 'theme_preference';

  @override
  Future<String?> fetchThemePreference() {
    return _preferences.getString(_themePreferenceKey);
  }

  @override
  Future<void> saveThemePreference(String value) {
    return _preferences.setString(_themePreferenceKey, value);
  }
}
