import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';

class EpisodeListState {
  const EpisodeListState({
    this.isLoading = false,
    this.episodes = const <Episode>[],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalEpisodes = 0,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Episode> episodes;
  final int currentPage;
  final int totalPages;
  final int totalEpisodes;
  final String? errorMessage;

  bool get hasContent => episodes.isNotEmpty;
  bool get hasError => errorMessage != null;
  bool get hasPreviousPage => currentPage > 1;
  bool get hasNextPage => currentPage < totalPages;
  int get startEpisodeNumber => ((currentPage - 1) * 10) + 1;
  int get endEpisodeNumber => startEpisodeNumber + episodes.length - 1;

  EpisodeListState copyWith({
    bool? isLoading,
    List<Episode>? episodes,
    int? currentPage,
    int? totalPages,
    int? totalEpisodes,
    Object? errorMessage = _noValue,
  }) {
    return EpisodeListState(
      isLoading: isLoading ?? this.isLoading,
      episodes: episodes ?? this.episodes,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      errorMessage: errorMessage == _noValue
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _noValue = Object();
}
