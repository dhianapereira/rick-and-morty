import 'package:rickandmorty/features/characters/domain/entities/character.dart';
import 'package:rickandmorty/features/characters/data/datasources/character_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/models/episode_api_details_model.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_details_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_details_repository.dart';

class EpisodeDetailsRepositoryImpl implements EpisodeDetailsRepository {
  EpisodeDetailsRepositoryImpl({
    required EpisodeDetailsRemoteDataSource remoteDataSource,
    required CharacterRemoteDataSource characterRemoteDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _characterRemoteDataSource = characterRemoteDataSource;

  final EpisodeDetailsRemoteDataSource _remoteDataSource;
  final CharacterRemoteDataSource _characterRemoteDataSource;

  @override
  Future<EpisodeDetails> fetchDetails(int episodeId) async {
    final EpisodeApiDetailsModel episode = await _remoteDataSource.fetchEpisode(
      episodeId,
    );
    final List<int> characterIds = episode.characterUrls
        .map(_extractCharacterId)
        .toList(growable: false);
    final List<Character> characters =
        (await _characterRemoteDataSource.fetchByIds(
          characterIds,
        )).map((character) => character.toEntity()).toList(growable: false);

    return EpisodeDetails(
      id: episode.id,
      name: episode.name,
      code: episode.code,
      airDate: episode.airDate,
      createdAt: episode.createdAt,
      characters: characters,
    );
  }

  int _extractCharacterId(String characterUrl) {
    return int.parse(Uri.parse(characterUrl).pathSegments.last);
  }
}
