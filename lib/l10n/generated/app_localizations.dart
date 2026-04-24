import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rick and Morty'**
  String get appName;

  /// No description provided for @episodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Episode Guide'**
  String get episodesTitle;

  /// No description provided for @episodesInitialDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore the journey from the first episode to the latest release.'**
  String get episodesInitialDescription;

  /// No description provided for @episodesRangeDescription.
  ///
  /// In en, this message translates to:
  /// **'Showing {startEpisodeNumber}-{endEpisodeNumber} of {totalEpisodes}'**
  String episodesRangeDescription(
    int startEpisodeNumber,
    int endEpisodeNumber,
    int totalEpisodes,
  );

  /// No description provided for @unableToLoadEpisodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load episodes'**
  String get unableToLoadEpisodesTitle;

  /// No description provided for @tryAgainLabel.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgainLabel;

  /// No description provided for @previousPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousPageLabel;

  /// No description provided for @nextPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextPageLabel;

  /// No description provided for @pageIndicatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {currentPage} of {totalPages}'**
  String pageIndicatorLabel(int currentPage, int totalPages);

  /// No description provided for @themeMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Theme options'**
  String get themeMenuTooltip;

  /// No description provided for @themeSystemLabel.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystemLabel;

  /// No description provided for @themeLightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLightLabel;

  /// No description provided for @themeDarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDarkLabel;

  /// No description provided for @episodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Episode {episodeId}'**
  String episodeTitle(int episodeId);

  /// No description provided for @episodeDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'{charactersCount} characters confirmed in this episode.'**
  String episodeDetailsDescription(int charactersCount);

  /// No description provided for @episodeCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Episode code'**
  String get episodeCodeLabel;

  /// No description provided for @episodeAirDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Air date'**
  String get episodeAirDateLabel;

  /// No description provided for @episodeCreatedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get episodeCreatedAtLabel;

  /// No description provided for @episodeCharactersCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get episodeCharactersCountLabel;

  /// No description provided for @episodeCharactersCountValue.
  ///
  /// In en, this message translates to:
  /// **'{count} total'**
  String episodeCharactersCountValue(int count);

  /// No description provided for @unableToLoadEpisodeDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load episode details'**
  String get unableToLoadEpisodeDetailsTitle;

  /// No description provided for @charactersTitle.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get charactersTitle;

  /// No description provided for @characterDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Character {characterId}'**
  String characterDetailsTitle(int characterId);

  /// No description provided for @characterDetailsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Character details will be added soon.'**
  String get characterDetailsPlaceholder;

  /// No description provided for @unableToLoadCharacterDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load character details'**
  String get unableToLoadCharacterDetailsTitle;

  /// No description provided for @characterPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get characterPlacesTitle;

  /// No description provided for @characterOriginLabel.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get characterOriginLabel;

  /// No description provided for @characterLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Last known location'**
  String get characterLocationLabel;

  /// No description provided for @characterGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get characterGenderLabel;

  /// No description provided for @characterEpisodesLabel.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get characterEpisodesLabel;

  /// No description provided for @characterCreatedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get characterCreatedAtLabel;

  /// No description provided for @characterStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get characterStatusLabel;

  /// No description provided for @characterEpisodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Episodes featured in'**
  String get characterEpisodesTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
