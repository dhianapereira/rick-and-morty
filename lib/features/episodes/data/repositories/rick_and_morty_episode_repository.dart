import 'dart:math';

import 'package:rickandmorty/features/episodes/data/datasources/episode_local_data_source.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/models/episode_api_page_model.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  EpisodeRepositoryImpl({
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

  @override
  Future<EpisodePage> searchEpisodes({
    required String query,
    required int page,
  }) async {
    final String normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      return fetchPage(page);
    }

    if (page < 1) {
      throw const EpisodeException('Page number must be greater than zero.');
    }

    final List<Episode> cachedMatches = await _searchCachedEpisodes(
      normalizedQuery,
    );
    final EpisodePage? cachedSearchPage = _buildSearchPage(
      episodes: cachedMatches,
      page: page,
    );

    if (cachedSearchPage != null) {
      return cachedSearchPage;
    }

    final int apiPage = ((page - 1) ~/ 2) + 1;
    final EpisodeApiPageModel apiResponse = await _remoteDataSource
        .searchByName(query: normalizedQuery, page: apiPage);

    return _mapApiResponseToPage(apiResponse: apiResponse, page: page);
  }

  Future<List<Episode>> _searchCachedEpisodes(String query) async {
    final List<EpisodePage> cachedPages = await _localDataSource
        .fetchAllPages();
    final List<Episode> cachedEpisodes = cachedPages
        .expand((EpisodePage page) => page.episodes)
        .toList(growable: false);
    final Map<int, Episode> uniqueEpisodes = <int, Episode>{
      for (final Episode episode in cachedEpisodes) episode.id: episode,
    };
    final String normalizedQuery = query.toLowerCase();

    return uniqueEpisodes.values
        .where(
          (Episode episode) =>
              episode.name.toLowerCase().contains(normalizedQuery) ||
              episode.code.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false)
      ..sort((Episode first, Episode second) => first.id.compareTo(second.id));
  }

  EpisodePage? _buildSearchPage({
    required List<Episode> episodes,
    required int page,
  }) {
    if (episodes.isEmpty) {
      return null;
    }

    final int totalPages = (episodes.length / pageSize).ceil();

    if (page > totalPages) {
      return null;
    }

    final int offset = (page - 1) * pageSize;
    final int end = min(offset + pageSize, episodes.length);

    return EpisodePage(
      episodes: episodes.sublist(offset, end),
      currentPage: page,
      totalPages: totalPages,
      totalEpisodes: episodes.length,
    );
  }

  EpisodePage _mapApiResponseToPage({
    required EpisodeApiPageModel apiResponse,
    required int page,
  }) {
    if (apiResponse.totalEpisodes == 0) {
      return const EpisodePage(
        episodes: <Episode>[],
        currentPage: 1,
        totalPages: 1,
        totalEpisodes: 0,
      );
    }

    final int totalPages = (apiResponse.totalEpisodes / pageSize).ceil();

    if (page > totalPages) {
      throw const EpisodeException('Page not found.');
    }

    final int offset = ((page - 1) % 2) * pageSize;
    final int end = min(offset + pageSize, apiResponse.episodes.length);

    return EpisodePage(
      episodes: apiResponse.episodes
          .sublist(offset, end)
          .toList(growable: false),
      currentPage: page,
      totalPages: totalPages,
      totalEpisodes: apiResponse.totalEpisodes,
    );
  }
}
