import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/data/repository/user_repository.dart';
import 'package:rick_and_morty/data/service/characters/service.dart';
import 'package:rick_and_morty/data/repository/character_repository.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_character_detail_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_characters_filtered_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_characters_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_login_status_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_login_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_logout_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_register_usecase.dart';
import 'package:rick_and_morty/presentation/states/character/character_detail_store.dart';
import 'package:rick_and_morty/presentation/states/character/character_store.dart';
import 'package:rick_and_morty/presentation/states/profile/login_store.dart';
import 'package:rick_and_morty/presentation/states/profile/registration_store.dart';

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
      ));
  getIt.registerLazySingleton<UserRepository>(() => UserRepository(
        getIt(),
      ));

  /// Usecases
  /// Character
  getIt.registerLazySingleton(() => GetCharactersUseCase(
        getIt(),
        getIt(),
      ));
  getIt.registerLazySingleton(
      () => GetCharacterDetailUseCase(repository: getIt()));
  getIt.registerLazySingleton(
      () => GetCharactersFilteredUseCase(repository: getIt()));

  /// User
  getIt.registerLazySingleton(() => UserRegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => UserLoginUseCase(getIt()));
  getIt.registerLazySingleton(() => UserLogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => UserLoginStatusUseCase(getIt()));

  /// Stores
  getIt.registerLazySingleton(() => CharacterStore(
        getCharactersUseCase: getIt(),
        getCharactersFilteredUseCase: getIt(),
      ));
  getIt.registerLazySingleton(() => CharacterDetailStore(
        getCharacterDetailUseCase: getIt(),
      ));
  getIt.registerLazySingleton(() => LoginStore(
        loginUseCase: getIt(),
        logoutUseCase: getIt(),
        loginStatusUseCase: getIt(),
      ));
  getIt
      .registerLazySingleton(() => RegistrationStore(registerUseCase: getIt()));
}
