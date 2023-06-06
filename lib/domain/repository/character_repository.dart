import 'package:rick_and_morty/data/model/response/response.dart';
import 'package:rick_and_morty/domain/entity/character/character.dart';

abstract class CharacterRepository {
  Future<CharacterListResponse> getCharacters(
    int page,
  );

  Future<Character> getCharacter(int id);

  Future<CharacterListResponse> getCharactersFiltered(
    int page,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  );
}
