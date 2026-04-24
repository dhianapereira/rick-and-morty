import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/application/router/app_router.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_state.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';
import 'package:rickandmorty/shared/shared.dart';

class _MockEpisodeListController extends Mock
    implements EpisodeListController {}

void main() {
  late EpisodeListController controller;
  late ValueNotifier<EpisodeListState> stateNotifier;

  setUp(() {
    controller = _MockEpisodeListController();
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

    GetIt.I.registerSingleton<EpisodeListController>(controller);
  });

  tearDown(() async {
    stateNotifier.dispose();
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

      expect(find.text('Episode 9'), findsOneWidget);
      expect(find.text('Characters'), findsOneWidget);
    },
  );
}
