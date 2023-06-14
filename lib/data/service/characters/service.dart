import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:rick_and_morty/data/model/character/character.dart';
import 'package:rick_and_morty/data/model/response/response.dart';

part 'service.g.dart';

@RestApi(baseUrl: "https://rickandmortyapi.com/api")
abstract class RickAndMortyService {
  factory RickAndMortyService(Dio dio, {String baseUrl}) = _RickAndMortyService;

  @GET('/character/{id}')
  Future<Character> getCharacter(@Path('id') int id);

  @GET('/character/')
  Future<CharacterListResponse> getCharacters(
    @Query('page') int page,
    @Query('name') String? name,
    @Query('status') String? status,
    @Query('species') String? species,
    @Query('type') String? type,
    @Query('gender') String? gender,
  );

  @GET('/character/{ids}')
  Future<List<Character>> getCharactersByIds(@Path('ids') String ids);
}
