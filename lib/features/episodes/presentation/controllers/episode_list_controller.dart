import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_repository.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_state.dart';

class EpisodeListController extends ValueNotifier<EpisodeListState> {
  EpisodeListController({
    required EpisodeRepository repository,
    this.searchDebounceDuration = const Duration(milliseconds: 350),
  }) : _repository = repository,
       super(const EpisodeListState());

  final EpisodeRepository _repository;
  final Duration searchDebounceDuration;
  Timer? _searchDebounce;
  int _requestId = 0;

  Future<void> loadInitialPage() async {
    if (value.hasContent) {
      return;
    }

    await loadPage(1);
  }

  Future<void> loadNextPage() async {
    if (!value.hasNextPage || value.isLoading) {
      return;
    }

    await loadPage(value.currentPage + 1);
  }

  Future<void> loadPreviousPage() async {
    if (!value.hasPreviousPage || value.isLoading) {
      return;
    }

    await loadPage(value.currentPage - 1);
  }

  Future<void> retry() async {
    await _loadPage(value.hasContent ? value.currentPage : 1);
  }

  Future<void> loadPage(int page) async {
    await _loadPage(page);
  }

  void updateSearchQuery(String query) {
    final String normalizedQuery = query.trim();

    if (normalizedQuery == value.searchQuery) {
      return;
    }

    _searchDebounce?.cancel();
    value = value.copyWith(searchQuery: normalizedQuery, errorMessage: null);
    _searchDebounce = Timer(searchDebounceDuration, () {
      unawaited(_loadPage(1, query: normalizedQuery));
    });
  }

  Future<void> _loadPage(int page, {String? query}) async {
    final int requestId = ++_requestId;
    final String activeQuery = (query ?? value.searchQuery).trim();

    value = value.copyWith(
      isLoading: true,
      searchQuery: activeQuery,
      errorMessage: null,
    );

    try {
      final EpisodePage episodePage = activeQuery.isEmpty
          ? await _repository.fetchPage(page)
          : await _repository.searchEpisodes(query: activeQuery, page: page);

      if (requestId != _requestId) {
        return;
      }

      value = value.copyWith(
        isLoading: false,
        episodes: episodePage.episodes,
        currentPage: episodePage.currentPage,
        totalPages: episodePage.totalPages,
        totalEpisodes: episodePage.totalEpisodes,
        errorMessage: null,
      );
    } on EpisodeException catch (exception) {
      if (requestId != _requestId) {
        return;
      }

      value = value.copyWith(isLoading: false, errorMessage: exception.message);
    } catch (_) {
      if (requestId != _requestId) {
        return;
      }

      value = value.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load episodes.',
      );
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
