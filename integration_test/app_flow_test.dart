import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rickandmorty/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Should navigate from episode list to character details When user completes the main flow',
    (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Rick and Morty'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey<String>('episode-list-next-button')),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Page 2 of 6'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey<String>('episode-list-search-field')),
        'Pilot',
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final Finder episodeFinder = find.byKey(
        const ValueKey<String>('episode-list-item-1'),
      );
      expect(episodeFinder, findsOneWidget);

      await tester.tap(episodeFinder);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Episode 1'), findsOneWidget);

      final Finder firstCharacterFinder = find.byWidgetPredicate((
        Widget widget,
      ) {
        final Key? key = widget.key;

        return key is ValueKey<String> &&
            key.value.startsWith('episode-character-item-');
      }).first;

      expect(firstCharacterFinder, findsOneWidget);

      await tester.tap(firstCharacterFinder);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(BackButton), findsOneWidget);
      expect(find.text('Rick Sanchez'), findsWidgets);
    },
  );
}
