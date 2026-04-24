import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_repository.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';

class _MockEpisodeRepository extends Mock implements EpisodeRepository {}

void main() {
  late EpisodeRepository repository;
  late EpisodeListController sut;

  setUp(() {
    repository = _MockEpisodeRepository();
    sut = EpisodeListController(
      repository: repository,
      searchDebounceDuration: const Duration(milliseconds: 1),
    );
  });

  test(
    'Should expose loaded episodes when initial page load succeeds',
    () async {
      when(
        () => repository.fetchPage(1),
      ).thenAnswer((_) async => _buildEpisodePage(page: 1));

      await sut.loadInitialPage();

      expect(sut.value.episodes.length, 10);
      expect(sut.value.currentPage, 1);
      expect(sut.value.hasNextPage, isTrue);
      expect(sut.value.isLoading, isFalse);
    },
  );

  test('Should load next page when next page is requested', () async {
    when(
      () => repository.fetchPage(1),
    ).thenAnswer((_) async => _buildEpisodePage(page: 1));
    when(
      () => repository.fetchPage(2),
    ).thenAnswer((_) async => _buildEpisodePage(page: 2));

    await sut.loadInitialPage();
    await sut.loadNextPage();

    expect(sut.value.currentPage, 2);
    expect(sut.value.episodes.first.id, 11);
  });

  test(
    'Should expose error message when repository throws exception',
    () async {
      when(
        () => repository.fetchPage(1),
      ).thenThrow(const EpisodeException('Unable to fetch episodes.'));

      await sut.loadInitialPage();

      expect(sut.value.hasError, isTrue);
      expect(sut.value.errorMessage, 'Unable to fetch episodes.');
      expect(sut.value.hasContent, isFalse);
    },
  );

  test(
    'Should search cached or remote episodes when search query changes',
    () async {
      when(() => repository.searchEpisodes(query: 'pilot', page: 1)).thenAnswer(
        (_) async => EpisodePage(
          currentPage: 1,
          totalPages: 1,
          totalEpisodes: 1,
          episodes: const <Episode>[
            Episode(
              id: 1,
              name: 'Pilot',
              code: 'S01E01',
              airDate: 'December 2, 2013',
            ),
          ],
        ),
      );

      sut.updateSearchQuery('pilot');
      await Future<void>.delayed(const Duration(milliseconds: 5));

      expect(sut.value.searchQuery, 'pilot');
      expect(sut.value.episodes.single.name, 'Pilot');
      verify(
        () => repository.searchEpisodes(query: 'pilot', page: 1),
      ).called(1);
    },
  );

  test(
    'Should clear previous results immediately when search query changes',
    () async {
      when(
        () => repository.fetchPage(1),
      ).thenAnswer((_) async => _buildEpisodePage(page: 1));
      when(() => repository.searchEpisodes(query: 'test', page: 1)).thenAnswer(
        (_) async => const EpisodePage(
          currentPage: 1,
          totalPages: 1,
          totalEpisodes: 0,
          episodes: <Episode>[],
        ),
      );

      await sut.loadInitialPage();
      sut.updateSearchQuery('test');

      expect(sut.value.searchQuery, 'test');
      expect(sut.value.episodes, isEmpty);
      expect(sut.value.totalEpisodes, 0);
    },
  );

  test(
    'Should ignore previous in flight search result when query changes',
    () async {
      final Completer<EpisodePage> oldSearchCompleter =
          Completer<EpisodePage>();

      when(
        () => repository.searchEpisodes(query: 'd', page: 1),
      ).thenAnswer((_) => oldSearchCompleter.future);
      when(() => repository.searchEpisodes(query: 'test', page: 1)).thenAnswer(
        (_) async => const EpisodePage(
          currentPage: 1,
          totalPages: 1,
          totalEpisodes: 0,
          episodes: <Episode>[],
        ),
      );

      sut.updateSearchQuery('d');
      await Future<void>.delayed(const Duration(milliseconds: 5));
      sut.updateSearchQuery('test');

      oldSearchCompleter.complete(
        EpisodePage(
          currentPage: 1,
          totalPages: 1,
          totalEpisodes: 1,
          episodes: const <Episode>[
            Episode(
              id: 1,
              name: 'Pilot',
              code: 'S01E01',
              airDate: 'December 2, 2013',
            ),
          ],
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 5));

      expect(sut.value.searchQuery, 'test');
      expect(sut.value.episodes, isEmpty);
      expect(sut.value.errorMessage, isNull);
    },
  );
}

EpisodePage _buildEpisodePage({required int page}) {
  final int startId = ((page - 1) * 10) + 1;

  return EpisodePage(
    currentPage: page,
    totalPages: 3,
    totalEpisodes: 30,
    episodes: List<Episode>.generate(
      10,
      (int index) => Episode(
        id: startId + index,
        name: 'Episode ${startId + index}',
        code: 'S01E${(startId + index).toString().padLeft(2, '0')}',
        airDate: 'December ${startId + index}, 2013',
      ),
      growable: false,
    ),
  );
}
