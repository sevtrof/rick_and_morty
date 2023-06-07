import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/domain/entity/location/location.dart';
import 'package:rick_and_morty/domain/entity/origin/origin.dart';
import 'package:rick_and_morty/domain/usecase/get_characters_usecase.dart';
import 'package:rick_and_morty/domain/usecase/get_characters_filtered_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/presentation/states/character_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'character_store_test.mocks.dart';

@GenerateMocks([GetCharactersUseCase, GetCharactersFilteredUseCase])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('CharacterStore Test', () {
    late CharacterStore store;
    late MockGetCharactersUseCase mockGetCharactersUseCase;
    late MockGetCharactersFilteredUseCase mockGetCharactersFilteredUseCase;
    late Character rick;

    setUp(() {
      mockGetCharactersUseCase = MockGetCharactersUseCase();
      mockGetCharactersFilteredUseCase = MockGetCharactersFilteredUseCase();
      store = CharacterStore(
        getCharactersUseCase: mockGetCharactersUseCase,
        getCharactersFilteredUseCase: mockGetCharactersFilteredUseCase,
      );
      rick = const Character(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: Origin(
            name: 'Earth', url: 'https://rickandmortyapi.com/api/location/1'),
        location: Location(
            name: 'Earth', url: 'https://rickandmortyapi.com/api/location/20'),
        image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        episode: [
          "https://rickandmortyapi.com/api/episode/1",
          "https://rickandmortyapi.com/api/episode/2",
        ],
        url: 'https://rickandmortyapi.com/api/character/1',
        created: '2017-11-04T18:48:46.250Z',
      );
    });

    test('fetchCharacters adds characters and increments currentPage',
        () async {
      final mockCharacters = [
        rick,
      ];
      when(mockGetCharactersUseCase.call(1))
          .thenAnswer((_) async => mockCharacters);

      await store.fetchCharacters();

      verify(mockGetCharactersUseCase.call(1)).called(1);
      expect(store.characters, mockCharacters);
      expect(store.currentPage, 2);
    });

    test(
        'fetchCharactersFiltered adds characters and increments currentPageFiltered',
        () async {
      final mockCharacters = [
        rick,
      ];

      when(mockGetCharactersFilteredUseCase.call(
        1,
        null,
        null,
        null,
        null,
        null,
      )).thenAnswer((_) async => mockCharacters);

      await store.fetchCharactersFiltered();

      verify(mockGetCharactersFilteredUseCase.call(
        1,
        null,
        null,
        null,
        null,
        null,
      )).called(1);
      expect(store.characters, mockCharacters);
      expect(store.currentPageFiltered, 2);
    });

    test('clearCharacters removes all characters and resets pages', () async {
      store.clearCharacters();

      expect(store.characters.length, 0);
      expect(store.currentPage, 1);
      expect(store.currentPageFiltered, 1);
    });

    test('addFavoriteCharacter adds character to favorites', () async {
      const characterId = 1;
      store.addFavoriteCharacter(characterId);

      expect(store.favoriteCharacters.contains(characterId), true);
    });

    test('removeFavoriteCharacter removes character from favorites', () async {
      const characterId = 1;
      store.addFavoriteCharacter(characterId);
      store.removeFavoriteCharacter(characterId);

      expect(store.favoriteCharacters.contains(characterId), false);
    });
  });
}
