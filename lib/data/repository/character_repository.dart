import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rick_and_morty/data/model/response/response.dart';
import 'package:rick_and_morty/data/service/service.dart';
import 'package:rick_and_morty/data/model/isar_character/isar_character.dart';
import 'package:rick_and_morty/data/model/location/location.dart';
import 'package:rick_and_morty/data/model/origin/origin.dart';
import 'package:rick_and_morty/data/model/character/character.dart';

class CharacterRepository {
  final RickAndMortyService service;
  Isar? isar;

  CharacterRepository(
    this.service,
  );

  Future<CharacterListResponse> getCharactersFromApi(int page) async {
    return await service.getCharacters(page);
  }

  Future<List<Character>> getCharactersFromIsar() async {
    if (isar == null) {
      final directory = await getApplicationDocumentsDirectory();
      isar = await Isar.open([CharacterIsarSchema], directory: directory.path);
    }

    final characters = await isar!.characterIsars.where().findAll();
    return characters
        .map((characterIsar) => Character(
              id: characterIsar.id!,
              name: characterIsar.name,
              status: characterIsar.status,
              species: characterIsar.species,
              type: characterIsar.type,
              gender: characterIsar.gender,
              origin: Origin(name: characterIsar.origin, url: ''),
              location: Location(name: characterIsar.location, url: ''),
              image: characterIsar.image,
              episode: characterIsar.episode.split(',').toList(),
              url: characterIsar.url,
              created: characterIsar.created,
            ))
        .toList();
  }

  Future<void> saveCharactersToIsar(List<Character> characters) async {
    if (isar == null) {
      final directory = await getApplicationDocumentsDirectory();
      isar = await Isar.open([CharacterIsarSchema], directory: directory.path);
    }

    await isar!.writeTxn(() async {
      for (var character in characters) {
        var characterIsar = CharacterIsar()
          ..id = character.id
          ..name = character.name
          ..status = character.status
          ..species = character.species
          ..type = character.type
          ..gender = character.gender
          ..origin = character.origin.name
          ..location = character.location.name
          ..image = character.image
          ..episode = character.episode.join(',')
          ..url = character.url
          ..created = character.created;
        await isar!.characterIsars.put(characterIsar);
      }
    });
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
      throw Exception('Error getting filtered characters: $error');
    }
  }

  Future<Character> getCharacter(int id) async {
    return await service.getCharacter(id);
  }
}
