// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rick and Morty';

  @override
  String get episodesTitle => 'Episode Guide';

  @override
  String get episodesInitialDescription =>
      'Explore the journey from the first episode to the latest release.';

  @override
  String episodesRangeDescription(
    int startEpisodeNumber,
    int endEpisodeNumber,
    int totalEpisodes,
  ) {
    return 'Showing $startEpisodeNumber-$endEpisodeNumber of $totalEpisodes';
  }

  @override
  String get unableToLoadEpisodesTitle => 'Unable to load episodes';

  @override
  String get tryAgainLabel => 'Try again';

  @override
  String get previousPageLabel => 'Previous';

  @override
  String get nextPageLabel => 'Next';

  @override
  String pageIndicatorLabel(int currentPage, int totalPages) {
    return 'Page $currentPage of $totalPages';
  }

  @override
  String get themeMenuTooltip => 'Theme options';

  @override
  String get themeSystemLabel => 'System';

  @override
  String get themeLightLabel => 'Light';

  @override
  String get themeDarkLabel => 'Dark';

  @override
  String episodeTitle(int episodeId) {
    return 'Episode $episodeId';
  }

  @override
  String episodeDetailsDescription(int charactersCount) {
    return '$charactersCount characters confirmed in this episode.';
  }

  @override
  String get episodeCodeLabel => 'Episode code';

  @override
  String get episodeAirDateLabel => 'Air date';

  @override
  String get episodeCreatedAtLabel => 'Created at';

  @override
  String get episodeCharactersCountLabel => 'Characters';

  @override
  String episodeCharactersCountValue(int count) {
    return '$count total';
  }

  @override
  String get unableToLoadEpisodeDetailsTitle =>
      'Unable to load episode details';

  @override
  String get charactersTitle => 'Characters';

  @override
  String characterDetailsTitle(int characterId) {
    return 'Character $characterId';
  }

  @override
  String get characterDetailsPlaceholder =>
      'Character details will be added soon.';
}
