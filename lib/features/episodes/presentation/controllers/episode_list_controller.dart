import 'package:flutter/foundation.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_repository.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_state.dart';

class EpisodeListController extends ValueNotifier<EpisodeListState> {
  EpisodeListController({required EpisodeRepository repository})
    : _repository = repository,
      super(const EpisodeListState());

  final EpisodeRepository _repository;

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
    await loadPage(value.hasContent ? value.currentPage : 1);
  }

  Future<void> loadPage(int page) async {
    if (value.isLoading) {
      return;
    }

    value = value.copyWith(isLoading: true, errorMessage: null);

    try {
      final EpisodePage episodePage = await _repository.fetchPage(page);

      value = value.copyWith(
        isLoading: false,
        episodes: episodePage.episodes,
        currentPage: episodePage.currentPage,
        totalPages: episodePage.totalPages,
        totalEpisodes: episodePage.totalEpisodes,
        errorMessage: null,
      );
    } on EpisodeException catch (exception) {
      value = value.copyWith(isLoading: false, errorMessage: exception.message);
    } catch (_) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load episodes.',
      );
    }
  }
}
