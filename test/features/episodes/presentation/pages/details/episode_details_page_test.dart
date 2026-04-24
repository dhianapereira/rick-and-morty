import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/application/router/app_router.dart';
import 'package:rickandmorty/features/characters/domain/entities/character.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_place.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_controller.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_state.dart';
import 'package:rickandmorty/features/characters/presentation/pages/details/character_details_page.dart';
import 'package:rickandmorty/features/characters/presentation/widgets/character_list_item.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_state.dart';
import 'package:rickandmorty/features/episodes/presentation/pages/details/episode_details_page.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';
import 'package:rickandmorty/shared/shared.dart';

class _MockEpisodeDetailsController extends Mock
    implements EpisodeDetailsController {}

class _MockCharacterDetailsController extends Mock
    implements CharacterDetailsController {}

void main() {
  late EpisodeDetailsController controller;
  late ValueNotifier<EpisodeDetailsState> stateNotifier;
  late CharacterDetailsController characterController;
  late ValueNotifier<CharacterDetailsState> characterStateNotifier;

  setUp(() {
    controller = _MockEpisodeDetailsController();
    characterController = _MockCharacterDetailsController();
    stateNotifier = ValueNotifier<EpisodeDetailsState>(
      EpisodeDetailsState(details: _details()),
    );
    characterStateNotifier = ValueNotifier<CharacterDetailsState>(
      CharacterDetailsState(details: _characterDetails()),
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
    when(() => controller.load()).thenAnswer((_) async {});
    when(() => controller.retry()).thenAnswer((_) async {});
    when(() => controller.dispose()).thenAnswer((_) {});
    when(
      () => characterController.value,
    ).thenAnswer((_) => characterStateNotifier.value);
    when(() => characterController.addListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      characterStateNotifier.addListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(() => characterController.removeListener(any())).thenAnswer((
      Invocation invocation,
    ) {
      characterStateNotifier.removeListener(
        invocation.positionalArguments.first as VoidCallback,
      );
    });
    when(() => characterController.load()).thenAnswer((_) async {});
    when(() => characterController.retry()).thenAnswer((_) async {});
    when(() => characterController.dispose()).thenAnswer((_) {});

    GetIt.I.registerFactoryParam<EpisodeDetailsController, int, void>(
      (int unusedEpisodeId, void _) => controller,
    );
    GetIt.I.registerFactoryParam<CharacterDetailsController, int, void>(
      (int unusedCharacterId, void _) => characterController,
    );
  });

  tearDown(() async {
    stateNotifier.dispose();
    characterStateNotifier.dispose();
    await GetIt.I.reset();
  });

  testWidgets('Should render episode details and characters when page loads', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('The Ricklantis Mixup'), findsOneWidget);
    expect(find.text('September 10, 2017'), findsOneWidget);
    expect(find.text('Rick Sanchez'), findsOneWidget);
    verify(() => controller.load()).called(1);
  });

  testWidgets(
    'Should open character details page when character card is tapped',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(CharacterListItem).first);
      await tester.tap(find.byType(CharacterListItem).first);
      await tester.pumpAndSettle();

      expect(find.text('Rick Sanchez'), findsNWidgets(2));
    },
  );
}

Widget _buildTestApp() {
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/episodes/:episodeId',
        builder: (BuildContext context, GoRouterState state) {
          final int episodeId = int.parse(state.pathParameters['episodeId']!);
          return EpisodeDetailsPage(episodeId: episodeId);
        },
      ),
      GoRoute(
        path: '/characters/:characterId',
        builder: (BuildContext context, GoRouterState state) {
          final int characterId = int.parse(
            state.pathParameters['characterId']!,
          );
          return CharacterDetailsPage(characterId: characterId);
        },
      ),
    ],
    initialLocation: AppRouter.episodeDetailsLocation(28),
  );

  return MaterialApp.router(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
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

CharacterDetails _characterDetails() {
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
    imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    episodeUrls: const <String>['https://rickandmortyapi.com/api/episode/1'],
    url: 'https://rickandmortyapi.com/api/character/1',
    createdAt: DateTime.utc(2017, 11, 4),
  );
}
