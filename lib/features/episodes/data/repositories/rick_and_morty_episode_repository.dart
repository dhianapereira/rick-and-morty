import 'dart:math';

import 'package:rickandmorty/features/episodes/data/datasources/episode_local_data_source.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/models/episode_api_page_model.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_repository.dart';

class RickAndMortyEpisodeRepository implements EpisodeRepository {
  RickAndMortyEpisodeRepository({
    required EpisodeLocalDataSource localDataSource,
    required EpisodeRemoteDataSource remoteDataSource,
    this.pageSize = 10,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final EpisodeLocalDataSource _localDataSource;
  final EpisodeRemoteDataSource _remoteDataSource;
  final int pageSize;

  @override
  Future<EpisodePage> fetchPage(int page) async {
    if (page < 1) {
      throw const EpisodeException('Page number must be greater than zero.');
    }

    final EpisodePage? cachedPage = await _localDataSource.fetchPage(page);

    if (cachedPage != null) {
      return cachedPage;
    }

    final int apiPage = ((page - 1) ~/ 2) + 1;
    final EpisodeApiPageModel apiResponse = await _remoteDataSource.fetchPage(
      apiPage,
    );
    final int totalPages = (apiResponse.totalEpisodes / pageSize).ceil();

    if (page > totalPages) {
      throw const EpisodeException('Page not found.');
    }

    final int offset = ((page - 1) % 2) * pageSize;
    final int end = min(offset + pageSize, apiResponse.episodes.length);
    final List<Episode> visibleEpisodes = apiResponse.episodes
        .sublist(offset, end)
        .toList(growable: false);

    final EpisodePage episodePage = EpisodePage(
      episodes: visibleEpisodes,
      currentPage: page,
      totalPages: totalPages,
      totalEpisodes: apiResponse.totalEpisodes,
    );

    await _localDataSource.savePage(episodePage);

    return episodePage;
  }
}
