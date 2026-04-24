import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_local_data_source.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/models/episode_api_page_model.dart';
import 'package:rickandmorty/features/episodes/data/repositories/rick_and_morty_episode_repository.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';

class _MockEpisodeRemoteDataSource extends Mock
    implements EpisodeRemoteDataSource {}

class _MockEpisodeLocalDataSource extends Mock
    implements EpisodeLocalDataSource {}

void main() {
  late EpisodeLocalDataSource localDataSource;
  late EpisodeRemoteDataSource remoteDataSource;
  late RickAndMortyEpisodeRepository sut;

  setUp(() {
    registerFallbackValue(
      const EpisodePage(
        episodes: <Episode>[],
        currentPage: 1,
        totalPages: 1,
        totalEpisodes: 0,
      ),
    );
    localDataSource = _MockEpisodeLocalDataSource();
    remoteDataSource = _MockEpisodeRemoteDataSource();
    sut = RickAndMortyEpisodeRepository(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  });

  test('Should return cached page when page exists locally', () async {
    final EpisodePage cachedPage = EpisodePage(
      episodes: const <Episode>[
        Episode(
          id: 1,
          name: 'Pilot',
          code: 'S01E01',
          airDate: 'December 2, 2013',
        ),
      ],
      currentPage: 1,
      totalPages: 5,
      totalEpisodes: 51,
    );

    when(
      () => localDataSource.fetchPage(1),
    ).thenAnswer((_) async => cachedPage);

    final EpisodePage result = await sut.fetchPage(1);

    expect(result, cachedPage);
    verify(() => localDataSource.fetchPage(1)).called(1);
    verifyNever(() => remoteDataSource.fetchPage(any()));
  });

  test(
    'Should fetch remote page and cache result when page does not exist locally',
    () async {
      when(() => localDataSource.fetchPage(1)).thenAnswer((_) async => null);
      when(
        () => remoteDataSource.fetchPage(1),
      ).thenAnswer((_) async => _buildApiPage(startId: 1, totalEpisodes: 41));
      when(() => localDataSource.savePage(any())).thenAnswer((_) async {});

      final EpisodePage result = await sut.fetchPage(1);

      expect(result.currentPage, 1);
      expect(result.totalPages, 5);
      expect(result.episodes.length, 10);
      expect(result.episodes.first.id, 1);
      expect(result.episodes.last.id, 10);
      verify(() => localDataSource.savePage(result)).called(1);
    },
  );

  test(
    'Should return second half from same api page when second application page is requested',
    () async {
      when(() => localDataSource.fetchPage(2)).thenAnswer((_) async => null);
      when(
        () => remoteDataSource.fetchPage(1),
      ).thenAnswer((_) async => _buildApiPage(startId: 1, totalEpisodes: 41));
      when(() => localDataSource.savePage(any())).thenAnswer((_) async {});

      final EpisodePage result = await sut.fetchPage(2);

      expect(result.currentPage, 2);
      expect(result.episodes.length, 10);
      expect(result.episodes.first.id, 11);
      expect(result.episodes.last.id, 20);
    },
  );

  test(
    'Should throw exception when requested page exceeds available pages',
    () async {
      when(() => localDataSource.fetchPage(4)).thenAnswer((_) async => null);
      when(
        () => remoteDataSource.fetchPage(2),
      ).thenAnswer((_) async => _buildApiPage(startId: 21, totalEpisodes: 21));

      expect(() => sut.fetchPage(4), throwsA(isA<EpisodeException>()));
    },
  );
}

EpisodeApiPageModel _buildApiPage({
  required int startId,
  required int totalEpisodes,
}) {
  return EpisodeApiPageModel(
    totalEpisodes: totalEpisodes,
    totalApiPages: (totalEpisodes / 20).ceil(),
    episodes: List<Episode>.generate(
      20,
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
