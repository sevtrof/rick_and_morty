import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/data/repository/character_repository.dart';
import 'package:rick_and_morty/domain/entity/character/character_ext.dart';

class GetCharactersFilteredUseCase {
  final CharacterRepository repository;

  GetCharactersFilteredUseCase({required this.repository});

  Future<List<Character>> call(
      int page,
      String? name,
      String? status,
      String? species,
      String? type,
      String? gender,
      ) async {
    final characterListResponse = await repository.getCharactersFiltered(
      page,
      name?.toLowerCase(),
      status,
      species,
      type,
      gender,
    );
    return characterListResponse.results
        .map((characterData) => characterData.toDomain())
        .toList();
  }

}
