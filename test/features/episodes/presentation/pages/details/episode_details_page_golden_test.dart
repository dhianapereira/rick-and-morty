@Tags(['skip_very_good_optimization'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/domain/entities/character.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_state.dart';
import 'package:rickandmorty/features/episodes/presentation/pages/details/episode_details_page.dart';
import 'package:rickandmorty/shared/shared.dart';

import '../../../../../utils/test_utils.dart';

class _MockEpisodeDetailsController extends Mock
    implements EpisodeDetailsController {}

void main() {
  group('EpisodeDetailsPage Golden Tests', () {
    late EpisodeDetailsController controller;
    late ValueNotifier<EpisodeDetailsState> stateNotifier;

    setUp(() {
      controller = _MockEpisodeDetailsController();
      stateNotifier = ValueNotifier<EpisodeDetailsState>(
        const EpisodeDetailsState(),
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

      GetIt.I.registerFactoryParam<EpisodeDetailsController, int, void>(
        (int unusedEpisodeId, void unused) => controller,
      );
    });

    tearDown(() async {
      stateNotifier.dispose();
      await GetIt.I.reset();
    });

    goldenTest(
      'Should render loaded episode details page when light theme is active',
      fileName: 'episode_details_page_loaded_light',
      builder: () {
        stateNotifier.value = EpisodeDetailsState(details: _details());

        return _buildGoldenScenario(theme: AppTheme.light);
      },
    );

    goldenTest(
      'Should render loaded episode details page when dark theme is active',
      fileName: 'episode_details_page_loaded_dark',
      builder: () {
        stateNotifier.value = EpisodeDetailsState(details: _details());

        return _buildGoldenScenario(theme: AppTheme.dark);
      },
    );

    goldenTest(
      'Should render error state when loading episode details fails',
      fileName: 'episode_details_page_error_light',
      builder: () {
        stateNotifier.value = const EpisodeDetailsState(
          errorMessage: 'Unable to reach the central finite curve.',
        );

        return _buildGoldenScenario(theme: AppTheme.light);
      },
    );
  });
}

Widget _buildGoldenScenario({required ThemeData theme}) {
  return buildMobileGoldenScenario(
    child: const EpisodeDetailsPage(episodeId: 28).toTestApp(theme: theme),
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
        imageUrl: 'invalid://rick-1',
      ),
      Character(
        id: 2,
        name: 'Morty Smith',
        status: 'Alive',
        species: 'Human',
        imageUrl: 'invalid://morty-2',
      ),
      Character(
        id: 3,
        name: 'Summer Smith',
        status: 'Alive',
        species: 'Human',
        imageUrl: 'invalid://summer-3',
      ),
      Character(
        id: 4,
        name: 'Mr. Poopybutthole',
        status: 'Alive',
        species: 'Poopybutthole',
        imageUrl: 'invalid://mpb-4',
      ),
    ],
  );
}
