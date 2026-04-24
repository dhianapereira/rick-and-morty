import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_place.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_controller.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_state.dart';
import 'package:rickandmorty/features/characters/presentation/pages/details/character_details_page.dart';
import 'package:rickandmorty/l10n/generated/app_localizations.dart';
import 'package:rickandmorty/shared/shared.dart';

class _MockCharacterDetailsController extends Mock
    implements CharacterDetailsController {}

void main() {
  late CharacterDetailsController controller;
  late ValueNotifier<CharacterDetailsState> stateNotifier;

  setUp(() {
    controller = _MockCharacterDetailsController();
    stateNotifier = ValueNotifier<CharacterDetailsState>(
      CharacterDetailsState(details: _details()),
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

    GetIt.I.registerFactoryParam<CharacterDetailsController, int, void>(
      (int unusedCharacterId, void _) => controller,
    );
  });

  tearDown(() async {
    stateNotifier.dispose();
    await GetIt.I.reset();
  });

  testWidgets('Should render character details when page loads', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Rick Sanchez'), findsNWidgets(2));
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Earth (C-137)'), findsOneWidget);
    expect(find.text('Places'), findsOneWidget);
    expect(find.text('Episode 1'), findsNothing);
    verify(() => controller.load()).called(1);
  });

  testWidgets('Should retry loading when try again button is tapped', (
    WidgetTester tester,
  ) async {
    stateNotifier.value = const CharacterDetailsState(
      errorMessage: 'Temporary failure.',
    );

    when(() => controller.retry()).thenAnswer((_) async {
      stateNotifier.value = CharacterDetailsState(details: _details());
    });

    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Rick Sanchez'), findsNWidgets(2));
    verify(() => controller.retry()).called(1);
  });
}

Widget _buildTestApp() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const CharacterDetailsPage(characterId: 1),
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
    ],
    url: 'https://rickandmortyapi.com/api/character/1',
    createdAt: DateTime.utc(2017, 11, 4),
  );
}
