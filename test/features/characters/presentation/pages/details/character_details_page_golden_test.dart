@Tags(['skip_very_good_optimization'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_place.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_controller.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_state.dart';
import 'package:rickandmorty/features/characters/presentation/pages/details/character_details_page.dart';
import 'package:rickandmorty/shared/shared.dart';

import '../../../../../utils/test_utils.dart';

class _MockCharacterDetailsController extends Mock
    implements CharacterDetailsController {}

void main() {
  group('CharacterDetailsPage Golden Tests', () {
    late CharacterDetailsController controller;
    late ValueNotifier<CharacterDetailsState> stateNotifier;

    setUp(() {
      controller = _MockCharacterDetailsController();
      stateNotifier = ValueNotifier<CharacterDetailsState>(
        const CharacterDetailsState(),
      );

      when(() => controller.value).thenAnswer((_) => stateNotifier.value);
      when(() => controller.addListener(any())).thenAnswer((
        Invocation invocation,
      ) {
        stateNotifier.addListener(
          invocation.positionalArguments.first as VoidCallback,
        );
      });
      when(() => controller.removeListener(any())).thenAnswer((
        Invocation invocation,
      ) {
        stateNotifier.removeListener(
          invocation.positionalArguments.first as VoidCallback,
        );
      });
      when(() => controller.dispose()).thenAnswer((_) {});
      when(() => controller.load()).thenAnswer((_) async {});
      when(() => controller.retry()).thenAnswer((_) async {});

      GetIt.I.registerFactoryParam<CharacterDetailsController, int, void>(
        (int unusedCharacterId, void unused) => controller,
      );
    });

    tearDown(() async {
      stateNotifier.dispose();
      await GetIt.I.reset();
    });

    goldenTest(
      'Should render loaded character details page when light theme is active',
      fileName: 'character_details_page_loaded_light',
      builder: () {
        stateNotifier.value = CharacterDetailsState(details: _details());

        return _buildGoldenScenario(theme: AppTheme.light);
      },
    );

    goldenTest(
      'Should render loaded character details page when dark theme is active',
      fileName: 'character_details_page_loaded_dark',
      builder: () {
        stateNotifier.value = CharacterDetailsState(details: _details());

        return _buildGoldenScenario(theme: AppTheme.dark);
      },
    );

    goldenTest(
      'Should render error state when loading character details fails',
      fileName: 'character_details_page_error_light',
      builder: () {
        stateNotifier.value = const CharacterDetailsState(
          errorMessage: 'Unable to reach the citadel records.',
        );

        return _buildGoldenScenario(theme: AppTheme.light);
      },
    );
  });
}

Widget _buildGoldenScenario({required ThemeData theme}) {
  return buildMobileGoldenScenario(
    child: const CharacterDetailsPage(characterId: 1).toTestApp(theme: theme),
  );
}

CharacterDetails _details() {
  return CharacterDetails(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    origin: const CharacterPlace(
      name: 'Earth (C-137)',
      url: 'https://rickandmortyapi.com/api/location/1',
    ),
    location: const CharacterPlace(
      name: 'Citadel of Ricks',
      url: 'https://rickandmortyapi.com/api/location/3',
    ),
    imageUrl: 'invalid://rick-1',
    episodeUrls: const <String>[
      'https://rickandmortyapi.com/api/episode/1',
      'https://rickandmortyapi.com/api/episode/2',
      'https://rickandmortyapi.com/api/episode/3',
    ],
    url: 'https://rickandmortyapi.com/api/character/1',
    createdAt: DateTime.utc(2017, 11, 4),
  );
}
