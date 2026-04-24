import 'package:get_it/get_it.dart';
import 'package:rickandmorty/features/characters/data/datasources/character_remote_data_source.dart';
import 'package:rickandmorty/features/characters/data/repositories/character_details_repository_impl.dart';
import 'package:rickandmorty/features/characters/domain/repositories/character_details_repository.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_controller.dart';
import 'package:rickandmorty/shared/http/client_http.dart';

class CharactersFeature {
  const CharactersFeature._();

  static const String key = 'characters';

  static Future<void> initialize() async {
    if (GetIt.I.isRegistered<CharacterDetailsController>()) {
      return;
    }

    GetIt.I.registerLazySingleton<CharacterRemoteDataSource>(
      () => ApiCharacterRemoteDataSource(clientHttp: GetIt.I<ClientHttp>()),
    );
    GetIt.I.registerLazySingleton<CharacterDetailsRepository>(
      () => CharacterDetailsRepositoryImpl(
        remoteDataSource: GetIt.I<CharacterRemoteDataSource>(),
      ),
    );
    GetIt.I.registerFactoryParam<CharacterDetailsController, int, void>(
      (int characterId, _) => CharacterDetailsController(
        repository: GetIt.I<CharacterDetailsRepository>(),
        characterId: characterId,
      ),
    );
  }
}
