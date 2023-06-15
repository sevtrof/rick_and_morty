import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_and_morty/data/model/character/character.dart';
import 'package:rick_and_morty/data/model/isar/character/isar_character.dart';
import 'package:rick_and_morty/data/model/location/location.dart';
import 'package:rick_and_morty/data/model/origin/origin.dart';
import 'package:rick_and_morty/data/model/response/response.dart';
import 'package:rick_and_morty/data/service/characters/service.dart';
import 'package:rick_and_morty/data/repository/character_repository.dart';

class MockRickAndMortyService extends Mock implements RickAndMortyService {}

class MockIsar extends Mock implements Isar {}

class MockIsarCollection extends Mock
    implements IsarCollection<CharacterIsar> {}

void main() {
  late CharacterRepository characterRepository;
  late RickAndMortyService mockService;
  late Isar mockIsar;

  setUp(() {
    mockService = MockRickAndMortyService();
    mockIsar = MockIsar();
    characterRepository = CharacterRepository(mockService);
  });

  group('CharacterRepository', () {
    test('getCharactersFromApi returns CharacterListResponse', () async {
      const page = 1;
      final expectedResponse = CharacterListResponse(
          info: Info(
            pages: 42,
            count: 826,
          ),
          results: [
            const Character(
              id: 1,
              name: 'Rick Sanchez',
              status: 'Alive',
              species: 'Human',
              type: '',
              gender: 'Male',
              origin: Origin(
                  name: 'Earth',
                  url: 'https://rickandmortyapi.com/api/location/1'),
              location: Location(
                  name: 'Earth',
                  url: 'https://rickandmortyapi.com/api/location/20'),
              image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
              episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2",
              ],
              url: 'https://rickandmortyapi.com/api/character/1',
              created: '2017-11-04T18:48:46.250Z',
            ),
          ]);

      when(mockService.getCharacters(page, null, null, null, null, null))
          .thenAnswer((_) => Future.value(expectedResponse));

      final response = await characterRepository.getCharactersFromApi(page,
          null, null, null, null, null);

      expect(response, equals(expectedResponse));
      verify(mockService.getCharacters(page, null, null, null, null, null))
          .called(1);
    });

    test('getCharactersFromIsar returns List<Character>', () async {
      final charactersInIsar = [CharacterIsar()];
      when(mockIsar.characterIsars.where().findAll())
          .thenAnswer((_) => Future.value(charactersInIsar));

      characterRepository.isar = mockIsar;

      final characters = await characterRepository.getCharactersFromIsar();

      expect(characters.length, equals(charactersInIsar.length));
      verify(mockIsar.characterIsars.where().findAll()).called(1);
    });
  });
}
