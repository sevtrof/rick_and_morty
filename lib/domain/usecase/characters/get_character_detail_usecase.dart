import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/domain/entity/character/character_ext.dart';
import 'package:rick_and_morty/data/repository/character_repository.dart';

class GetCharacterDetailUseCase {
  final CharacterRepository repository;

  GetCharacterDetailUseCase({required this.repository});

  Future<Character> call(int id) async {
    final character = await repository.getCharacter(id);
    return character.toDomain();
  }
}