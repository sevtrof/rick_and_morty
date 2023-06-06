import 'package:rick_and_morty/data/api/service/service.dart';
import 'package:rick_and_morty/data/model/response/response.dart';
import 'package:rick_and_morty/data/model/character/character.dart';

class CharacterRepository {
  final RickAndMortyService service;

  CharacterRepository(this.service);

  Future<CharacterListResponse> getCharacters(int page) async {
    try {
      final characterListResponse = await service.getCharacters(page);
      return characterListResponse;
    } catch (error) {
      throw Exception('Error getting characters: $error');
    }
  }

  Future<Character> getCharacter(int id) async {
    try {
      return await service.getCharacter(id);
    } catch (error) {
      throw Exception('Error getting character: $error');
    }
  }

  Future<CharacterListResponse> getCharactersFiltered(
    int page,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  ) async {
    try {
      final characterListResponse = await service.getCharactersFiltered(
        page,
        name,
        status,
        species,
        type,
        gender,
      );
      return characterListResponse;
    } catch (error) {
      throw Exception('Error getting characters: $error');
    }
  }
}
