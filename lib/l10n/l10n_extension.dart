import 'package:flutter/widgets.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';

extension BuildContextL10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
