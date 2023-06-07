import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';
import 'package:rick_and_morty/data/model/character/character.dart';
import 'package:rick_and_morty/data/model/isar_character/isar_character.dart';
import 'package:rick_and_morty/data/repository/character_repository.dart';
import 'package:rick_and_morty/domain/entity/character/character.dart' as domain;
import 'package:rick_and_morty/domain/entity/character/character_ext.dart';

class GetCharactersUseCase {
  final CharacterRepository repository;
  final Connectivity connectivity;
  int _totalCharacters = 0;

  GetCharactersUseCase(
      this.repository,
      this.connectivity,
      );

  Future<List<domain.Character>> call(int page) async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    List<Character> characters;

    if (result == ConnectivityResult.none) {
      characters = await repository.getCharactersFromIsar();
    } else {
      characters = (await repository.getCharactersFromApi(page)).results;

      if (page == 1) {
        _totalCharacters = characters.length;
      }

      int? storedCharacterCount =
      await repository.isar?.characterIsars.where().count();

      if (storedCharacterCount != null &&
          storedCharacterCount < _totalCharacters) {
        await repository.saveCharactersToIsar(characters);
      }
    }

    return characters.map<domain.Character>((characterData) => characterData.toDomain()).toList();
  }
}
