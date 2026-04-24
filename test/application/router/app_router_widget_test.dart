import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rickandmorty/application/router/app_router.dart';
import 'package:rickandmorty/shared/shared.dart';

void main() {
  testWidgets(
    'Should open episodes page when router starts at initial location',
    (WidgetTester tester) async {
      final GoRouter router = AppRouter.createRouter(
        navigatorKey: GlobalKey<NavigatorState>(),
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rick and Morty'), findsOneWidget);
      expect(find.text('Episodes'), findsOneWidget);
    },
  );

  testWidgets(
    'Should open episode details page when details route is requested',
    (WidgetTester tester) async {
      final GoRouter router = AppRouter.createRouter(
        navigatorKey: GlobalKey<NavigatorState>(),
      );

      await tester.pumpWidget(
        MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      );

      router.go(AppRouter.episodeDetailsLocation(9));
      await tester.pumpAndSettle();

      expect(find.text('Episode 9'), findsOneWidget);
      expect(find.text('Characters'), findsOneWidget);
    },
  );
}
