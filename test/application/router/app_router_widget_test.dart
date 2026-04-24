import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/domain/entities/character.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_place.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_controller.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_state.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_state.dart';
import 'package:rickandmorty/application/router/app_router.dart';
import 'package:rickandmorty/application/theme/app_theme_preference.dart';
import 'package:rickandmorty/application/theme/theme_controller.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_state.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';
import 'package:rickandmorty/shared/shared.dart';

class _MockEpisodeListController extends Mock
    implements EpisodeListController {}

class _MockEpisodeDetailsController extends Mock
    implements EpisodeDetailsController {}

class _MockCharacterDetailsController extends Mock
    implements CharacterDetailsController {}

class _MockThemeController extends Mock implements ThemeController {}

void main() {
  late EpisodeListController controller;
  late ValueNotifier<EpisodeListState> stateNotifier;
  late EpisodeDetailsController detailsController;
  late ValueNotifier<EpisodeDetailsState> detailsNotifier;
  late CharacterDetailsController characterDetailsController;
  late ValueNotifier<CharacterDetailsState> characterDetailsNotifier;
  late ThemeController themeController;
  late ValueNotifier<AppThemePreference> themeNotifier;

  setUp(() {
    controller = _MockEpisodeListController();
    detailsController = _MockEpisodeDetailsController();
    characterDetailsController = _MockCharacterDetailsController();
    themeController = _MockThemeController();
    stateNotifier = ValueNotifier<EpisodeListState>(
      EpisodeListState(
        episodes: const <Episode>[
          Episode(
            id: 1,
            name: 'Pilot',
            code: 'S01E01',
            airDate: 'December 2, 2013',
          ),
        ],
        totalEpisodes: 1,
      ),
    );
    themeNotifier = ValueNotifier<AppThemePreference>(
      AppThemePreference.system,
    );
    detailsNotifier = ValueNotifier<EpisodeDetailsState>(
      EpisodeDetailsState(
        details: EpisodeDetails(
          id: 9,
          name: 'Something Ricked This Way Comes',
          code: 'S01E09',
          airDate: 'March 24, 2014',
          createdAt: DateTime.utc(2017, 11, 10),
          characters: const <Character>[
            Character(
              id: 1,
              name: 'Rick Sanchez',
              status: 'Alive',
              species: 'Human',
              imageUrl:
                  'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            ),
          ],
        ),
      ),
    );
    characterDetailsNotifier = ValueNotifier<CharacterDetailsState>(
      CharacterDetailsState(
        details: CharacterDetails(
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
          imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
          episodeUrls: const <String>[
            'https://rickandmortyapi.com/api/episode/1',
          ],
          url: 'https://rickandmortyapi.com/api/character/1',
          createdAt: DateTime.utc(2017, 11, 4),
        ),
      ),
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
    when(() => controller.loadInitialPage()).thenAnswer((_) async {});
    when(() => controller.updateSearchQuery(any())).thenReturn(null);
    when(() => controller.dispose()).thenAnswer((_) {});
    when(
      () => detailsController.value,
    ).thenAnswer((_) => detailsNotifier.value);
    when(() => detailsController.addListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      detailsNotifier.addListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(() => detailsController.removeListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      detailsNotifier.removeListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(() => detailsController.load()).thenAnswer((_) async {});
    when(() => detailsController.retry()).thenAnswer((_) async {});
    when(() => detailsController.dispose()).thenAnswer((_) {});
    when(
      () => characterDetailsController.value,
    ).thenAnswer((_) => characterDetailsNotifier.value);
    when(() => characterDetailsController.addListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      characterDetailsNotifier.addListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(() => characterDetailsController.removeListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      characterDetailsNotifier.removeListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(() => characterDetailsController.load()).thenAnswer((_) async {});
    when(() => characterDetailsController.retry()).thenAnswer((_) async {});
    when(() => characterDetailsController.dispose()).thenAnswer((_) {});
    when(() => themeController.value).thenAnswer((_) => themeNotifier.value);
    when(() => themeController.addListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      themeNotifier.addListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(() => themeController.removeListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      themeNotifier.removeListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(
      () => themeController.updateThemePreference(AppThemePreference.system),
    ).thenAnswer((_) async {});
    when(
      () => themeController.updateThemePreference(AppThemePreference.light),
    ).thenAnswer((_) async {});
    when(
      () => themeController.updateThemePreference(AppThemePreference.dark),
    ).thenAnswer((_) async {});

    GetIt.I.registerSingleton<EpisodeListController>(controller);
    GetIt.I.registerFactoryParam<EpisodeDetailsController, int, void>(
      (int unusedEpisodeId, void _) => detailsController,
    );
    GetIt.I.registerFactoryParam<CharacterDetailsController, int, void>(
      (int unusedCharacterId, void _) => characterDetailsController,
    );
    GetIt.I.registerSingleton<ThemeController>(themeController);
  });

  tearDown(() async {
    stateNotifier.dispose();
    detailsNotifier.dispose();
    characterDetailsNotifier.dispose();
    themeNotifier.dispose();
    await GetIt.I.reset();
  });

  testWidgets(
    'Should open episodes page when router starts at initial location',
    (WidgetTester tester) async {
      final GoRouter router = AppRouter.createRouter(
        navigatorKey: GlobalKey<NavigatorState>(),
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.light,
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rick and Morty'), findsOneWidget);
      expect(find.text('Episode Guide'), findsOneWidget);
    },
  );

  testWidgets(
    'Should open episode details page when details route is requested',
    (WidgetTester tester) async {
      final GoRouter router = AppRouter.createRouter(
        navigatorKey: GlobalKey<NavigatorState>(),
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.light,
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      router.go(AppRouter.episodeDetailsLocation(9));
      await tester.pumpAndSettle();

      expect(find.text('Something Ricked This Way Comes'), findsOneWidget);
      expect(find.text('Episode 9'), findsOneWidget);
      expect(find.text('Characters'), findsNWidgets(2));
    },
  );

  testWidgets(
    'Should show back button when episode details page is opened by push',
    (WidgetTester tester) async {
      final GoRouter router = AppRouter.createRouter(
        navigatorKey: GlobalKey<NavigatorState>(),
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.light,
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilot'));
      await tester.pumpAndSettle();

      expect(find.text('Episode 1'), findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);
    },
  );

  testWidgets(
    'Should open character details page when character route is requested',
    (WidgetTester tester) async {
      final GoRouter router = AppRouter.createRouter(
        navigatorKey: GlobalKey<NavigatorState>(),
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.light,
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      router.go(AppRouter.characterDetailsLocation(1));
      await tester.pumpAndSettle();

      expect(find.text('Rick Sanchez'), findsNWidgets(2));
      expect(find.text('Character 1'), findsNothing);
    },
  );
}
