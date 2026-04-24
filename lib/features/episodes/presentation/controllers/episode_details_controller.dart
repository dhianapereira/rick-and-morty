import 'package:flutter/foundation.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_details_repository.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_state.dart';

class EpisodeDetailsController extends ValueNotifier<EpisodeDetailsState> {
  EpisodeDetailsController({
    required EpisodeDetailsRepository repository,
    required int episodeId,
  }) : _repository = repository,
       _episodeId = episodeId,
       super(const EpisodeDetailsState());

  final EpisodeDetailsRepository _repository;
  final int _episodeId;

  Future<void> load() async {
    if (value.isLoading) {
      return;
    }

    if (value.details?.id == _episodeId) {
      return;
    }

    value = value.copyWith(isLoading: true, errorMessage: null);

    try {
      final EpisodeDetails details = await _repository.fetchDetails(_episodeId);
      value = value.copyWith(
        isLoading: false,
        details: details,
        errorMessage: null,
      );
    } on EpisodeException catch (exception) {
      value = value.copyWith(isLoading: false, errorMessage: exception.message);
    } catch (_) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load episode details.',
      );
    }
  }

  Future<void> retry() {
    return load();
  }
}
