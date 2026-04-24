import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/data/datasources/character_remote_data_source.dart';
import 'package:rickandmorty/features/characters/data/models/character_api_model.dart';
import 'package:rickandmorty/features/characters/data/models/character_place_api_model.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_details_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/models/episode_api_details_model.dart';
import 'package:rickandmorty/features/episodes/data/repositories/rick_and_morty_episode_details_repository.dart';

class _MockEpisodeDetailsRemoteDataSource extends Mock
    implements EpisodeDetailsRemoteDataSource {}

class _MockCharacterRemoteDataSource extends Mock
    implements CharacterRemoteDataSource {}

void main() {
  late EpisodeDetailsRemoteDataSource remoteDataSource;
  late CharacterRemoteDataSource characterRemoteDataSource;
  late EpisodeDetailsRepositoryImpl sut;

  setUp(() {
    remoteDataSource = _MockEpisodeDetailsRemoteDataSource();
    characterRemoteDataSource = _MockCharacterRemoteDataSource();
    sut = EpisodeDetailsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      characterRemoteDataSource: characterRemoteDataSource,
    );
  });

  test(
    'Should map episode details and fetch characters in batch when details are requested',
    () async {
      when(() => remoteDataSource.fetchEpisode(28)).thenAnswer(
        (_) async => EpisodeApiDetailsModel(
          id: 28,
          name: 'The Ricklantis Mixup',
          code: 'S03E07',
          airDate: 'September 10, 2017',
          createdAt: DateTime.utc(2017, 11, 10),
          characterUrls: const <String>[
            'https://rickandmortyapi.com/api/character/1',
            'https://rickandmortyapi.com/api/character/2',
          ],
        ),
      );
      when(
        () => characterRemoteDataSource.fetchByIds(const <int>[1, 2]),
      ).thenAnswer(
        (_) async => <CharacterApiModel>[
          CharacterApiModel(
            id: 1,
            name: 'Rick Sanchez',
            status: 'Alive',
            species: 'Human',
            type: '',
            gender: 'Male',
            origin: CharacterPlaceApiModel(name: 'Earth', url: ''),
            location: CharacterPlaceApiModel(name: 'Earth', url: ''),
            imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            episodeUrls: <String>['https://rickandmortyapi.com/api/episode/1'],
            url: 'https://rickandmortyapi.com/api/character/1',
            createdAt: DateTime.utc(2017, 11, 4),
          ),
          CharacterApiModel(
            id: 2,
            name: 'Morty Smith',
            status: 'Alive',
            species: 'Human',
            type: '',
            gender: 'Male',
            origin: CharacterPlaceApiModel(name: 'Earth', url: ''),
            location: CharacterPlaceApiModel(name: 'Earth', url: ''),
            imageUrl: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
            episodeUrls: <String>['https://rickandmortyapi.com/api/episode/1'],
            url: 'https://rickandmortyapi.com/api/character/2',
            createdAt: DateTime.utc(2017, 11, 4),
          ),
        ],
      );

      final result = await sut.fetchDetails(28);

      expect(result.id, 28);
      expect(result.characters.length, 2);
      expect(result.characters.first.name, 'Rick Sanchez');
      verify(() => remoteDataSource.fetchEpisode(28)).called(1);
      verify(
        () => characterRemoteDataSource.fetchByIds(const <int>[1, 2]),
      ).called(1);
    },
  );
}
