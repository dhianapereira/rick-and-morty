import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rickandmorty/application/router/app_router.dart';
import 'package:rickandmorty/application/theme/app_theme_preference.dart';
import 'package:rickandmorty/application/theme/theme_controller.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';
import 'package:rickandmorty/shared/shared.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key}) : _themeController = GetIt.I<ThemeController>();

  final ThemeController _themeController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemePreference>(
      valueListenable: _themeController,
      builder: (_, preference, _) {
        return MaterialApp.router(
          onGenerateTitle: (BuildContext context) => context.l10n.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: preference.themeMode,
          themeAnimationDuration: const Duration(milliseconds: 300),
          themeAnimationCurve: Curves.easeInOutCubic,
          routerConfig: AppRouter.router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
