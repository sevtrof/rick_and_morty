import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'news_api_service.g.dart';

@RestApi(baseUrl: "http://localhost:8080/api")
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String baseUrl}) = _NewsApiService;

  @POST("/news")
  Future<HttpResponse> fetchNews(
      @Query('page') int page);
}
