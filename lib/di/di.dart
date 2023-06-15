import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/data/repository/news_repository.dart';
import 'package:rick_and_morty/data/repository/user_repository.dart';
import 'package:rick_and_morty/data/service/characters/service.dart';
import 'package:rick_and_morty/data/repository/character_repository.dart';
import 'package:rick_and_morty/data/service/news/news_api_service.dart';
import 'package:rick_and_morty/data/service/user/user_api_service.dart';
import 'package:rick_and_morty/data/storage/auth_storage.dart';
import 'package:rick_and_morty/domain/usecase/characters/add_favourite_character_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/fetch_favourite_characters_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_character_detail_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_characters_by_ids_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_characters_filtered_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_characters_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/remove_favourite_character_usecase.dart';
import 'package:rick_and_morty/domain/usecase/news/fetch_news_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_login_status_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_login_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_logout_usecase.dart';
import 'package:rick_and_morty/domain/usecase/user/user_register_usecase.dart';
import 'package:rick_and_morty/presentation/states/character/character_detail_store.dart';
import 'package:rick_and_morty/presentation/states/character/character_store.dart';
import 'package:rick_and_morty/presentation/states/news/news_store.dart';
import 'package:rick_and_morty/presentation/states/profile/registration_store.dart';
import 'package:rick_and_morty/presentation/states/profile/user_store.dart';

GetIt getIt = GetIt.instance;

void setupDependencies() {
  /// Dio
  getIt.registerLazySingleton(() => Dio());

  /// Internet connection
  getIt.registerLazySingleton(() => Connectivity());

  /// Service
  getIt.registerLazySingleton(() => RickAndMortyService(getIt.get()));
  getIt.registerLazySingleton(() => UserApiService(getIt.get()));
  getIt.registerLazySingleton(() => NewsApiService(getIt.get()));

  /// Storage
  getIt.registerLazySingleton(() => AuthStorage());

  /// Repository
  getIt.registerLazySingleton<CharacterRepository>(() => CharacterRepository(
        getIt(),
      ));
  getIt.registerLazySingleton<UserRepository>(() => UserRepository(
        getIt(),
        getIt(),
      ));
  getIt.registerLazySingleton<NewsRepository>(() => NewsRepository(
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
  getIt.registerLazySingleton(
      () => GetCharactersByIdsUseCase(repository: getIt()));

  /// Favourite chars
  getIt.registerLazySingleton(
      () => AddFavouriteCharacterUseCase(userRepository: getIt()));
  getIt.registerLazySingleton(
      () => RemoveFavouriteCharacterUseCase(userRepository: getIt()));
  getIt.registerLazySingleton(
      () => FetchFavouriteCharactersUseCase(userRepository: getIt()));

  /// User
  getIt.registerLazySingleton(() => UserRegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => UserLoginUseCase(getIt()));
  getIt.registerLazySingleton(() => UserLogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => UserLoginStatusUseCase(getIt()));

  /// News
  getIt.registerLazySingleton(() => FetchNewsUseCase(newsRepository: getIt()));

  /// Stores
  getIt.registerLazySingleton(() => CharacterStore(
        getCharactersUseCase: getIt(),
        getCharactersFilteredUseCase: getIt(),
        addFavouriteCharacterUseCase: getIt(),
        removeFavouriteCharacterUseCase: getIt(),
        fetchFavouriteCharactersUseCase: getIt(),
        getCharactersByIdsUseCase: getIt(),
      ));
  getIt.registerLazySingleton(() => CharacterDetailStore(
        getCharacterDetailUseCase: getIt(),
      ));
  getIt
      .registerLazySingleton(() => RegistrationStore(registerUseCase: getIt()));
  getIt.registerLazySingleton(() => UserStore(
        loginUseCase: getIt(),
        logoutUseCase: getIt(),
        loginStatusUseCase: getIt(),
        fetchFavouriteCharactersUseCase: getIt(),
      ));
  getIt.registerLazySingleton(() => NewsStore(
        getNewsUseCase: getIt(),
      ));
}
