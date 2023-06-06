import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/data/repository/character_repository.dart';
import 'package:rick_and_morty/domain/entity/character/character_ext.dart';

class GetCharactersUseCase {
  final CharacterRepository repository;

  GetCharactersUseCase({required this.repository});

  Future<List<Character>> call(int page) async {
    final characterListResponse = await repository.getCharacters(page);
    return characterListResponse.results
        .map((characterData) => characterData.toDomain())
        .toList();
  }
}
