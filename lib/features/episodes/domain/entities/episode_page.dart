import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';

class EpisodePage {
  const EpisodePage({
    required this.episodes,
    required this.currentPage,
    required this.totalPages,
    required this.totalEpisodes,
  });

  final List<Episode> episodes;
  final int currentPage;
  final int totalPages;
  final int totalEpisodes;
}
