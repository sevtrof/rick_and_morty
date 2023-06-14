import 'package:rick_and_morty/data/repository/character_repository.dart';
import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/domain/entity/character/character_ext.dart';

class GetCharactersByIdsUseCase {
  final CharacterRepository repository;

  GetCharactersByIdsUseCase({required this.repository});

  Future<List<Character>> call(List<int> ids) async {
    final characters = await repository.getCharactersByIds(ids);
    return characters.map((e) => e.toDomain()).toList();
  }
}
