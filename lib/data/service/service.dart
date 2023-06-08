import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:rick_and_morty/data/model/character/character.dart';
import 'package:rick_and_morty/data/model/response/response.dart';

part 'service.g.dart';

@RestApi()
abstract class RickAndMortyService {
  factory RickAndMortyService(Dio dio, {String? baseUrl}) {
    if (Platform.isIOS) {
      baseUrl = "http://localhost:8080/api";
    } else if (Platform.isAndroid) {
      baseUrl = "http://10.0.2.2:8080/api";
    }
    return _RickAndMortyService(dio, baseUrl: baseUrl);
  }

  @GET('/character')
  Future<CharacterListResponse> getCharacters(@Query('page') int page);

  @GET('/character/{id}')
  Future<Character> getCharacter(@Path('id') int id);

  @GET('/character/')
  Future<CharacterListResponse> getCharactersFiltered(
    @Query('page') int page,
    @Query('name') String? name,
    @Query('status') String? status,
    @Query('species') String? species,
    @Query('type') String? type,
    @Query('gender') String? gender,
  );
}
