import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rick_and_morty/data/service/user/user_api_service.dart';
import 'package:rick_and_morty/domain/common/either.dart';
import 'package:rick_and_morty/domain/common/failure.dart';
import 'package:rick_and_morty/domain/common/success.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final UserApiService _userApiService;
  static const String _userTokenKey = 'user_token';

  UserRepository(Dio dio) : _userApiService = UserApiService(dio);

  Future<Either<Failure, Success<Map<String, dynamic>>>> register(
      String username, String email, String password) async {
    try {
      final response = await _userApiService.register(
          {'username': username, "email": email, 'password': password});

      if (response.response.statusCode == 201) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData = json.decode(response.data);
        } else {
          responseData = response.data;
        }
        return Either(success: Success(responseData));
      } else {
        return Either(failure: ServerFailure(message: 'Registration failed'));
      }
    } catch (e) {
      return Either(
          failure: ServerFailure(message: 'Error during registration: $e'));
    }
  }

  Future<Either<Failure, Success<Map<String, dynamic>>>> login(
      String email, String password) async {
    try {
      final response =
          await _userApiService.login({'email': email, 'password': password});
      final token = response.data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_userTokenKey, token);
      }
      return Either(success: Success(response.data));
    } catch (e) {
      return Either(failure: ServerFailure());
    }
  }

  Future<Either<Failure, Success<void>>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(_userTokenKey);
      await _userApiService.logout();
      return Either(success: Success(null));
    } catch (e) {
      return Either(failure: ServerFailure());
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTokenKey) != null;
  }
}
