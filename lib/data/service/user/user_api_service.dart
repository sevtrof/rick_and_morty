import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: "http://localhost:8080/api")
abstract class UserApiService {
  factory UserApiService(Dio dio, {String baseUrl}) = _UserApiService;

  @POST("/register")
  Future<HttpResponse> register(@Body() Map<String, dynamic> user);

  @POST("/login")
  Future<HttpResponse> login(@Body() Map<String, dynamic> user);

  @POST("/logout")
  Future<HttpResponse> logout();
}
