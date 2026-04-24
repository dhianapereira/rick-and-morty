@Tags(['skip_very_good_optimization'])
library;

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_state.dart';
import 'package:rickandmorty/features/episodes/presentation/pages/episode_list_page.dart';
import 'package:rickandmorty/shared/shared.dart';

import '../../../../utils/test_utils.dart';

class _MockEpisodeListController extends Mock
    implements EpisodeListController {}

void main() {
  group('EpisodeListPage Golden Tests', () {
    late EpisodeListController controller;
    late ValueNotifier<EpisodeListState> stateNotifier;

    setUp(() {
      controller = _MockEpisodeListController();
      stateNotifier = ValueNotifier<EpisodeListState>(const EpisodeListState());

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
      when(() => controller.loadInitialPage()).thenAnswer((_) async {});
      when(() => controller.loadNextPage()).thenAnswer((_) async {});
      when(() => controller.loadPreviousPage()).thenAnswer((_) async {});
      when(() => controller.retry()).thenAnswer((_) async {});

      GetIt.I.registerSingleton<EpisodeListController>(controller);
    });

    tearDown(() async {
      stateNotifier.dispose();
      await GetIt.I.reset();
    });

    goldenTest(
      'Should render loaded episode list page when light theme is active',
      fileName: 'episode_list_page_loaded_light',
      builder: () {
        stateNotifier.value = _buildLoadedState();

        return _buildGoldenScenario(theme: AppTheme.light);
      },
    );

    goldenTest(
      'Should render loaded episode list page when dark theme is active',
      fileName: 'episode_list_page_loaded_dark',
      builder: () {
        stateNotifier.value = _buildLoadedState();

        return _buildGoldenScenario(theme: AppTheme.dark);
      },
    );

    goldenTest(
      'Should render error state when loading episodes fails',
      fileName: 'episode_list_page_error_light',
      builder: () {
        stateNotifier.value = const EpisodeListState(
          errorMessage: 'Unable to reach the portal gun network.',
        );

        return _buildGoldenScenario(theme: AppTheme.light);
      },
    );
  });
}

Widget _buildGoldenScenario({required ThemeData theme}) {
  return buildMobileGoldenScenario(
    child: const Scaffold(body: EpisodeListPage()).toTestApp(theme: theme),
  );
}

EpisodeListState _buildLoadedState() {
  return EpisodeListState(
    currentPage: 1,
    totalPages: 6,
    totalEpisodes: 51,
    episodes: const <Episode>[
      Episode(
        id: 1,
        name: 'Pilot',
        code: 'S01E01',
        airDate: 'December 2, 2013',
      ),
      Episode(
        id: 2,
        name: 'Lawnmower Dog',
        code: 'S01E02',
        airDate: 'December 9, 2013',
      ),
      Episode(
        id: 3,
        name: 'Anatomy Park',
        code: 'S01E03',
        airDate: 'December 16, 2013',
      ),
      Episode(
        id: 4,
        name: 'M. Night Shaym-Aliens!',
        code: 'S01E04',
        airDate: 'January 13, 2014',
      ),
    ],
  );
}
