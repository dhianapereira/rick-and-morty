import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_state.dart';
import 'package:rickandmorty/features/episodes/presentation/pages/episode_list_page.dart';
import 'package:rickandmorty/shared/shared.dart';

class _MockEpisodeListController extends Mock
    implements EpisodeListController {}

void main() {
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

  testWidgets(
    'Should render first page episodes when screen loads successfully',
    (WidgetTester tester) async {
      stateNotifier.value = _buildLoadedState(page: 1);

      await tester.pumpWidget(_buildTestApp());
      await tester.pump();

      expect(find.text('Episode Guide'), findsOneWidget);
      expect(find.text('Episode 1'), findsOneWidget);
      expect(find.text('Page 1 of 3'), findsOneWidget);
      verify(() => controller.loadInitialPage()).called(1);
    },
  );

  testWidgets('Should load next page when next button is tapped', (
    WidgetTester tester,
  ) async {
    stateNotifier.value = _buildLoadedState(page: 1);

    when(() => controller.loadNextPage()).thenAnswer((_) async {
      stateNotifier.value = _buildLoadedState(page: 2);
    });

    await tester.pumpWidget(_buildTestApp());
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Next'));
    await tester.pump();

    expect(find.text('Episode 11'), findsOneWidget);
    expect(find.text('Page 2 of 3'), findsOneWidget);
    verify(() => controller.loadNextPage()).called(1);
  });

  testWidgets('Should retry loading when try again button is tapped', (
    WidgetTester tester,
  ) async {
    stateNotifier.value = const EpisodeListState(
      errorMessage: 'Temporary failure.',
    );

    when(() => controller.retry()).thenAnswer((_) async {
      stateNotifier.value = _buildLoadedState(page: 1);
    });

    await tester.pumpWidget(_buildTestApp());
    await tester.pump();

    expect(find.text('Unable to load episodes'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
    await tester.pump();

    expect(find.text('Episode 1'), findsOneWidget);
    verify(() => controller.retry()).called(1);
  });
}

Widget _buildTestApp() {
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const EpisodeListPage(),
      ),
      GoRoute(
        path: '/episodes/:episodeId',
        builder: (BuildContext context, GoRouterState state) =>
            const SizedBox.shrink(),
      ),
    ],
  );

  return MaterialApp.router(theme: AppTheme.light, routerConfig: router);
}

EpisodeListState _buildLoadedState({required int page}) {
  final int startId = ((page - 1) * 10) + 1;

  return EpisodeListState(
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
