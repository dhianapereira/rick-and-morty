import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/application/router/app_route_names.dart';
import 'package:rickandmorty/application/router/app_route_parameters.dart';
import 'package:rickandmorty/application/router/app_route_paths.dart';
import 'package:rickandmorty/application/router/app_router.dart';

void main() {
  test('Should expose episodes as initial location when router is created', () {
    expect(AppRouter.initialLocation, AppRoutePaths.episodes);
  });

  test(
    'Should generate episode details location when router helper is used',
    () {
      expect(AppRouter.episodeDetailsLocation(7), '/episodes/7');
    },
  );

  test(
    'Should keep route metadata stable when navigation contract is queried',
    () {
      expect(AppRouteNames.episodes, 'episodes');
      expect(AppRouteNames.episodeDetails, 'episode-details');
      expect(AppRouteParameters.episodeId, 'episodeId');
      expect(AppRoutePaths.episodeDetails, '/episodes/:episodeId');
    },
  );
}
