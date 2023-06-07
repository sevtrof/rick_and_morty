import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/data/service/service.dart';
import 'package:rick_and_morty/data/repository/character_repository.dart';
import 'package:rick_and_morty/domain/usecase/get_character_detail_usecase.dart';
import 'package:rick_and_morty/domain/usecase/get_characters_filtered_usecase.dart';
import 'package:rick_and_morty/domain/usecase/get_characters_usecase.dart';
import 'package:rick_and_morty/presentation/states/character_detail_store.dart';
import 'package:rick_and_morty/presentation/states/character_store.dart';

GetIt getIt = GetIt.instance;

void setupDependencies() {
  /// Dio
  getIt.registerLazySingleton(() => Dio());

  /// Internet connection
  getIt.registerLazySingleton(() => Connectivity());

  /// Service
  getIt.registerLazySingleton(() => RickAndMortyService(getIt.get()));

  /// Repository
  getIt.registerLazySingleton<CharacterRepository>(() => CharacterRepository(
        getIt(),
        getIt(),
      ));

  /// Use cases
  getIt.registerLazySingleton(() => GetCharactersUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => GetCharacterDetailUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => GetCharactersFilteredUseCase(repository: getIt()));

  /// Store
  getIt.registerLazySingleton(() => CharacterStore(
        getCharactersUseCase: getIt(),
        getCharactersFilteredUseCase: getIt(),
      ));

  getIt.registerLazySingleton(() => CharacterDetailStore(
        getCharacterDetailUseCase: getIt(),
      ));
}
