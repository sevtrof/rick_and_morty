import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/domain/entity/location/location.dart';
import 'package:rick_and_morty/domain/entity/origin/origin.dart';
import 'package:rick_and_morty/domain/usecase/get_character_detail_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/presentation/states/character_detail_store.dart';

import 'character_detail_store_test.mocks.dart';

@GenerateMocks([GetCharacterDetailUseCase])
void main() {
  group('CharacterDetailStore Test', () {
    late CharacterDetailStore store;
    late MockGetCharacterDetailUseCase mockGetCharacterDetailUseCase;
    late Character rick;

    setUp(() {
      mockGetCharacterDetailUseCase = MockGetCharacterDetailUseCase();
      store = CharacterDetailStore(
          getCharacterDetailUseCase: mockGetCharacterDetailUseCase);

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

    test(
        'fetchCharacterDetail updates selectedCharacter with the fetched character',
        () async {
      when(mockGetCharacterDetailUseCase.call(1)).thenAnswer((_) async => rick);

      await store.fetchCharacterDetail(1);

      verify(mockGetCharacterDetailUseCase.call(1)).called(1);
      expect(store.selectedCharacter, rick);
    });

    test(
        'fetchCharacterDetail throws an exception when usecase throws an exception',
        () async {
      when(mockGetCharacterDetailUseCase.call(1))
          .thenThrow(Exception('Something went wrong'));

      expect(() => store.fetchCharacterDetail(1), throwsA(isA<Exception>()));

      verify(mockGetCharacterDetailUseCase.call(1)).called(1);
    });

    test('selectedCharacter should be null initially', () {
      expect(store.selectedCharacter, null);
    });

    test('error should be null initially', () {
      expect(store.error, null);
    });
  });
}
