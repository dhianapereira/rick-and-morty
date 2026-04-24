import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/domain/entities/character.dart';
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

class _MockThemeController extends Mock implements ThemeController {}

void main() {
  late EpisodeListController controller;
  late ValueNotifier<EpisodeListState> stateNotifier;
  late EpisodeDetailsController detailsController;
  late ValueNotifier<EpisodeDetailsState> detailsNotifier;
  late ThemeController themeController;
  late ValueNotifier<AppThemePreference> themeNotifier;

  setUp(() {
    controller = _MockEpisodeListController();
    detailsController = _MockEpisodeDetailsController();
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
    GetIt.I.registerSingleton<ThemeController>(themeController);
  });

  tearDown(() async {
    stateNotifier.dispose();
    detailsNotifier.dispose();
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
}
