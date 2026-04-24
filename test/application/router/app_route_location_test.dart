import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/application/router/app_route_location.dart';

void main() {
  test('Should build episode details path when episode id is provided', () {
    expect(AppRouteLocation.episodeDetails(42), '/episodes/42');
  });

  test('Should build character details path when character id is provided', () {
    expect(AppRouteLocation.characterDetails(8), '/characters/8');
  });
}
