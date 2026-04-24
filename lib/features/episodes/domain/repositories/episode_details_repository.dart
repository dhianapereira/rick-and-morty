import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';

abstract interface class EpisodeDetailsRepository {
  Future<EpisodeDetails> fetchDetails(int episodeId);
}
