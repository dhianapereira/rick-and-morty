import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/application/theme/app_theme_preference.dart';
import 'package:rickandmorty/application/theme/theme_controller.dart';
import 'package:rickandmorty/application/theme/theme_local_data_source.dart';

class _MockThemeLocalDataSource extends Mock implements ThemeLocalDataSource {}

void main() {
  late ThemeLocalDataSource localDataSource;
  late ThemeController controller;

  setUp(() {
    localDataSource = _MockThemeLocalDataSource();
    controller = ThemeController(localDataSource: localDataSource);
  });

  test(
    'Should restore saved theme preference when stored value exists',
    () async {
      when(
        () => localDataSource.fetchThemePreference(),
      ).thenAnswer((_) async => 'dark');

      await controller.loadThemePreference();

      expect(controller.value, AppThemePreference.dark);
    },
  );

  test(
    'Should persist selected theme preference when preference changes',
    () async {
      when(
        () => localDataSource.saveThemePreference('light'),
      ).thenAnswer((_) async {});

      await controller.updateThemePreference(AppThemePreference.light);

      expect(controller.value, AppThemePreference.light);
      verify(() => localDataSource.saveThemePreference('light')).called(1);
    },
  );

  test(
    'Should avoid persistence when selected theme preference matches current value',
    () async {
      await controller.updateThemePreference(AppThemePreference.system);

      verifyNever(() => localDataSource.saveThemePreference(any()));
    },
  );
}
