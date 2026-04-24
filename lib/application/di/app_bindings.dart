import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rickandmorty/application/config/app_environment.dart';
import 'package:rickandmorty/application/di/feature_registry.dart';
import 'package:rickandmorty/application/theme/theme_controller.dart';
import 'package:rickandmorty/application/theme/theme_local_data_source.dart';
import 'package:rickandmorty/features/characters/characters_feature.dart';
import 'package:rickandmorty/features/episodes/episodes_feature.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBindings {
  const AppBindings._();

  static Future<void> setup() async {
    if (GetIt.I.isRegistered<ThemeController>()) {
      return;
    }

    if (AppEnvironment.apiBaseUrl.isEmpty) {
      throw StateError(
        'RICK_AND_MORTY_API_BASE_URL is not configured. '
        'Run the app with --dart-define-from-file=env/development.json.',
      );
    }

    final SharedPreferencesAsync sharedPreferences = SharedPreferencesAsync();
    final FeatureRegistry featureRegistry = FeatureRegistry.instance;

    GetIt.I.registerSingleton<SharedPreferencesAsync>(sharedPreferences);
    GetIt.I.registerLazySingleton<ClientHttp>(
      () =>
          ClientHttp(options: BaseOptions(baseUrl: AppEnvironment.apiBaseUrl)),
    );
    GetIt.I.registerLazySingleton<ThemeLocalDataSource>(
      () => SharedPreferencesThemeLocalDataSource(
        preferences: GetIt.I<SharedPreferencesAsync>(),
      ),
    );
    GetIt.I.registerSingleton<ThemeController>(
      ThemeController(localDataSource: GetIt.I<ThemeLocalDataSource>()),
    );
    featureRegistry.reset();
    featureRegistry.register(
      featureKey: CharactersFeature.key,
      initializer: CharactersFeature.initialize,
    );
    featureRegistry.register(
      featureKey: EpisodesFeature.key,
      initializer: EpisodesFeature.initialize,
      dependencies: const <String>[CharactersFeature.key],
    );
    await GetIt.I<ThemeController>().loadThemePreference();
  }

  static Future<void> initializeFeature(String featureKey) {
    return FeatureRegistry.instance.initialize(featureKey);
  }
}
