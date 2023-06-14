import 'package:mobx/mobx.dart';
import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/domain/usecase/characters/add_favourite_character_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/fetch_favourite_characters_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_characters_by_ids_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_characters_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_characters_filtered_usecase.dart';
import 'package:rick_and_morty/domain/usecase/characters/remove_favourite_character_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'character_store.g.dart';

class CharacterStore = CharacterStoreBase with _$CharacterStore;

abstract class CharacterStoreBase with Store {
  final GetCharactersUseCase getCharactersUseCase;
  final GetCharactersFilteredUseCase getCharactersFilteredUseCase;
  final AddFavouriteCharacterUseCase addFavouriteCharacterUseCase;
  final RemoveFavouriteCharacterUseCase removeFavouriteCharacterUseCase;
  final FetchFavouriteCharactersUseCase fetchFavouriteCharactersUseCase;
  final GetCharactersByIdsUseCase getCharactersByIdsUseCase;

  CharacterStoreBase({
    required this.getCharactersUseCase,
    required this.getCharactersFilteredUseCase,
    required this.addFavouriteCharacterUseCase,
    required this.removeFavouriteCharacterUseCase,
    required this.fetchFavouriteCharactersUseCase,
    required this.getCharactersByIdsUseCase,
  });

  @observable
  ObservableList<Character> characters = ObservableList<Character>();

  @observable
  ObservableSet<int> favouriteCharacters = ObservableSet<int>();

  @observable
  Character? selectedCharacter;

  @observable
  String? error;

  @observable
  int currentPage = 1;

  @observable
  int currentPageFiltered = 1;

  @action
  Future<void> fetchCharacters() async {
    try {
      final result = await getCharactersUseCase.call(currentPage);
      characters.addAll(result);
      currentPage++;
    } catch (e) {
      throw Exception('Error fetching characters: $e');
    }
  }

  @action
  Future<void> fetchCharactersFiltered({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    bool clearList = false,
  }) async {
    if (clearList) {
      characters.clear();
      currentPageFiltered = 1;
    }
    try {
      final result = await getCharactersFilteredUseCase.call(
        currentPageFiltered,
        name,
        status,
        species,
        type,
        gender?.toLowerCase(),
      );
      characters.addAll(result);
      currentPageFiltered++;
    } catch (e) {
      throw Exception('Error fetching filtered characters: $e');
    }
  }

  @action
  Future<void> fetchNextPage({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  }) async {
    if (name?.isNotEmpty == true ||
        status?.isNotEmpty == true ||
        species?.isNotEmpty == true ||
        type?.isNotEmpty == true ||
        gender?.isNotEmpty == true) {
      await fetchCharactersFiltered(
        name: name,
        status: status,
        species: species,
        type: type,
        gender: gender,
      );
    } else {
      await fetchCharacters();
    }
  }

  @action
  Future<void> saveFavouriteCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favouriteCharacters',
        favouriteCharacters.map((id) => id.toString()).toList());
  }

  @action
  Future<void> addFavouriteCharacter(int characterId) async {
    try {
      await addFavouriteCharacterUseCase.call(characterId);
      favouriteCharacters.add(characterId);
      saveFavouriteCharacters();
    } catch (e) {
      throw Exception('Error adding favourite character: $e');
    }
  }

  @action
  Future<void> removeFavouriteCharacter(int characterId) async {
    try {
      await removeFavouriteCharacterUseCase.call(characterId);
      favouriteCharacters.remove(characterId);
      saveFavouriteCharacters();
    } catch (e) {
      throw Exception('Error removing favourite character: $e');
    }
  }

  @action
  Future<void> fetchFavouriteCharacters() async {
    try {
      final result = await fetchFavouriteCharactersUseCase.call();
      favouriteCharacters =
          ObservableSet<int>.of(result.success!.value.map((id) => id));
    } catch (e) {
      throw Exception('Error fetching favourite characters: $e');
    }
  }

  @action
  Future<void> fetchCharactersByIds(List<int> ids) async {
    try {
      List<Character> fetchedCharacters = await getCharactersByIdsUseCase.call(ids);
      characters.addAll(fetchedCharacters);
    } catch (e) {
      throw Exception('Error fetching characters by ids: $e');
    }
  }


  @action
  void clearCharacters() {
    characters.clear();
    currentPage = 1;
    currentPageFiltered = 1;
  }
}
