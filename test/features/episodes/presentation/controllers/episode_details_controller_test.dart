import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/domain/entities/character.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_details_repository.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_controller.dart';

class _MockEpisodeDetailsRepository extends Mock
    implements EpisodeDetailsRepository {}

void main() {
  late EpisodeDetailsRepository repository;
  late EpisodeDetailsController sut;

  setUp(() {
    repository = _MockEpisodeDetailsRepository();
    sut = EpisodeDetailsController(repository: repository, episodeId: 28);
  });

  test('Should expose episode details when loading succeeds', () async {
    when(() => repository.fetchDetails(28)).thenAnswer((_) async => _details());

    await sut.load();

    expect(sut.value.details?.id, 28);
    expect(sut.value.details?.characters.length, 2);
    expect(sut.value.isLoading, isFalse);
  });

  test(
    'Should expose error message when repository throws exception',
    () async {
      when(
        () => repository.fetchDetails(28),
      ).thenThrow(const EpisodeException('Unable to load episode details.'));

      await sut.load();

      expect(sut.value.hasError, isTrue);
      expect(sut.value.errorMessage, 'Unable to load episode details.');
    },
  );
}

EpisodeDetails _details() {
  return EpisodeDetails(
    id: 28,
    name: 'The Ricklantis Mixup',
    code: 'S03E07',
    airDate: 'September 10, 2017',
    createdAt: DateTime.utc(2017, 11, 10),
    characters: const <Character>[
      Character(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      ),
      Character(
        id: 2,
        name: 'Morty Smith',
        status: 'Alive',
        species: 'Human',
        imageUrl: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
      ),
    ],
  );
}
