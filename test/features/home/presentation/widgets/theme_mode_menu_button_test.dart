import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/application/theme/app_theme_preference.dart';
import 'package:rickandmorty/application/theme/theme_controller.dart';
import 'package:rickandmorty/features/home/presentation/widgets/theme_mode_menu_button.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';

class _MockThemeController extends Mock implements ThemeController {}

void main() {
  late ThemeController controller;
  late ValueNotifier<AppThemePreference> notifier;

  setUp(() {
    controller = _MockThemeController();
    notifier = ValueNotifier<AppThemePreference>(AppThemePreference.system);

    when(() => controller.value).thenAnswer((_) => notifier.value);
    when(() => controller.addListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      notifier.addListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(() => controller.removeListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      notifier.removeListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(
      () => controller.updateThemePreference(AppThemePreference.system),
    ).thenAnswer((_) async {});
    when(
      () => controller.updateThemePreference(AppThemePreference.light),
    ).thenAnswer((_) async {});
    when(
      () => controller.updateThemePreference(AppThemePreference.dark),
    ).thenAnswer((_) async {});

    GetIt.I.registerSingleton<ThemeController>(controller);
  });

  tearDown(() async {
    notifier.dispose();
    await GetIt.I.reset();
  });

  testWidgets('Should show theme options when theme menu button is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.tap(find.byIcon(Icons.brightness_auto_rounded));
    await tester.pumpAndSettle();

    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });

  testWidgets('Should update theme preference when dark option is selected', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.tap(find.byIcon(Icons.brightness_auto_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    verify(
      () => controller.updateThemePreference(AppThemePreference.dark),
    ).called(1);
  });
}

Widget _buildTestApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(appBar: AppBar(actions: <Widget>[ThemeModeMenuButton()])),
  );
}
