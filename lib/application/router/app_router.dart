import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rickandmorty/application/router/app_route_location.dart';
import 'package:rickandmorty/application/router/app_route_names.dart';
import 'package:rickandmorty/application/router/app_route_parameters.dart';
import 'package:rickandmorty/application/router/app_route_paths.dart';
import 'package:rickandmorty/features/characters/presentation/pages/details/character_details_page.dart';
import 'package:rickandmorty/features/episodes/presentation/pages/details/episode_details_page.dart';
import 'package:rickandmorty/features/episodes/presentation/pages/episode_list_page.dart';
import 'package:rickandmorty/features/home/presentation/pages/home_page.dart';

class AppRouter {
  const AppRouter._();

  static const String initialLocation = AppRoutePaths.episodes;

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = createRouter();

  static GoRouter createRouter({GlobalKey<NavigatorState>? navigatorKey}) {
    return GoRouter(
      navigatorKey: navigatorKey ?? rootNavigatorKey,
      initialLocation: initialLocation,
      routes: <RouteBase>[
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return HomePage(child: child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.episodes,
              name: AppRouteNames.episodes,
              builder: (BuildContext context, GoRouterState state) =>
                  const EpisodeListPage(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutePaths.episodeDetails,
          name: AppRouteNames.episodeDetails,
          builder: (BuildContext context, GoRouterState state) {
            final String episodeId =
                state.pathParameters[AppRouteParameters.episodeId]!;

            return EpisodeDetailsPage(episodeId: int.parse(episodeId));
          },
        ),
        GoRoute(
          path: AppRoutePaths.characterDetails,
          name: AppRouteNames.characterDetails,
          builder: (BuildContext context, GoRouterState state) {
            final String characterId =
                state.pathParameters[AppRouteParameters.characterId]!;

            return CharacterDetailsPage(characterId: int.parse(characterId));
          },
        ),
      ],
      debugLogDiagnostics: false,
    );
  }

  static String episodeDetailsLocation(int episodeId) {
    return AppRouteLocation.episodeDetails(episodeId);
  }

  static String characterDetailsLocation(int characterId) {
    return AppRouteLocation.characterDetails(characterId);
  }
}
