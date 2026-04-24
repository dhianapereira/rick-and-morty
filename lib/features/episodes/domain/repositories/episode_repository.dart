import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';

abstract interface class EpisodeRepository {
  Future<EpisodePage> fetchPage(int page);
}
