import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/application/router/app_route_location.dart';

void main() {
  test('Should build episode details path when episode id is provided', () {
    expect(AppRouteLocation.episodeDetails(42), '/episodes/42');
  });
}
