import 'package:flutter/material.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';
import 'package:rickandmorty/shared/shared.dart';

extension WidgetTestExtension on Widget {
  MaterialApp toTestApp({ThemeData? theme}) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: this,
    );
  }
}
