import 'package:rickandmorty/application/router/app_route_paths.dart';

class AppRouteLocation {
  const AppRouteLocation._();

  static String episodeDetails(int episodeId) {
    return '${AppRoutePaths.episodes}/$episodeId';
  }

  static String characterDetails(int characterId) {
    return '/characters/$characterId';
  }
}
