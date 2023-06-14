import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:rick_and_morty/data/service/user/user_api_service.dart';
import 'package:rick_and_morty/data/storage/auth_storage.dart';
import 'package:rick_and_morty/domain/common/either.dart';
import 'package:rick_and_morty/domain/common/failure.dart';
import 'package:rick_and_morty/domain/common/success.dart';

class UserRepository {
  UserApiService _userApiService;
  final AuthStorage _authStorage;
  final Dio _dio;

  UserRepository(this._userApiService, this._authStorage) : _dio = Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      final token = await _authStorage.getUserToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }));
    _userApiService = UserApiService(_dio);
  }

  Future<Either<Failure, Success<Map<String, dynamic>>>> register(
      String username, String email, String password) async {
    return _handleRequest(() async {
      final response = await _userApiService.register(
          {'username': username, "email": email, 'password': password});

      final responseData = _parseResponseData(response.data);
      await _authStorage.saveUserId(responseData['user_id']);

      return Success(responseData);
    });
  }

  Future<Either<Failure, Success<Map<String, dynamic>>>> login(
      String email, String password) async {
    return _handleRequest(() async {
      final response =
          await _userApiService.login({'email': email, 'password': password});

      await _authStorage.saveUserToken(response.data['token']);

      return Success(response.data);
    });
  }

  Future<Either<Failure, T>> _handleRequest<T>(
      Future<T> Function() request) async {
    try {
      final result = await request();
      return Either(success: result);
    } catch (e) {
      return Either(failure: ServerFailure(message: e.toString()));
    }
  }

  Map<String, dynamic> _parseResponseData(dynamic data) {
    if (data is String) {
      return json.decode(data);
    } else {
      return data;
    }
  }

  Future<Either<Failure, Success<void>>> addFavoriteCharacter(
      int characterId) async {
    try {
      final response = await _userApiService
          .addFavoriteCharacter({"characterId": characterId});
      if (response.response.statusCode == 201) {
        return Either(success: Success(null));
      } else {
        return Either(
            failure:
                ServerFailure(message: 'Failed to add favorite character'));
      }
    } catch (e) {
      return Either(
          failure: ServerFailure(
              message: 'Error during adding favorite character: $e'));
    }
  }

  Future<Either<Failure, Success<void>>> removeFavoriteCharacter(
      int characterId) async {
    try {
      final response = await _userApiService
          .removeFavoriteCharacter({"characterId": characterId});
      if (response.response.statusCode == 200) {
        return Either(success: Success(null));
      } else {
        return Either(
            failure:
                ServerFailure(message: 'Failed to remove favorite character'));
      }
    } catch (e) {
      return Either(
          failure: ServerFailure(
              message: 'Error during removing favorite character: $e'));
    }
  }

  Future<Either<Failure, Success<List<int>>>> fetchFavoriteCharacters() async {
    try {
      final response = await _userApiService.fetchFavoriteCharacters();
      if (response.response.statusCode == 200) {
        List<int> characterIds;
        if (response.data is String) {
          characterIds = List<int>.from(json.decode(response.data));
        } else {
          characterIds = List<int>.from(response.data);
        }
        return Either(success: Success(characterIds));
      } else {
        return Either(
            failure:
                ServerFailure(message: 'Failed to fetch favorite characters'));
      }
    } catch (e) {
      return Either(
          failure: ServerFailure(
              message: 'Error during fetching favorite characters: $e'));
    }
  }

  Future<Either<Failure, Success<void>>> logout() async {
    try {
      await _authStorage.removeUserToken();
      await _userApiService.logout();
      return Either(success: Success(null));
    } catch (e) {
      return Either(failure: ServerFailure());
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _authStorage.getUserToken();
    return token != null;
  }
}
