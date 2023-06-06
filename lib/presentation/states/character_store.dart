import 'package:mobx/mobx.dart';
import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/domain/usecase/get_characters_usecase.dart';
import 'package:rick_and_morty/domain/usecase/get_characters_filtered_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'character_store.g.dart';

class CharacterStore = CharacterStoreBase with _$CharacterStore;

abstract class CharacterStoreBase with Store {
  final GetCharactersUseCase getCharactersUseCase;
  final GetCharactersFilteredUseCase getCharactersFilteredUseCase;

  CharacterStoreBase({
    required this.getCharactersUseCase,
    required this.getCharactersFilteredUseCase,
  });

  @observable
  ObservableList<Character> characters = ObservableList<Character>();

  @observable
  ObservableSet<int> favoriteCharacters = ObservableSet<int>();

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
    final result = await getCharactersUseCase.call(currentPage);
    characters.addAll(result);
    currentPage++;
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
  Future<void> saveFavoriteCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteCharacters',
        favoriteCharacters.map((id) => id.toString()).toList());
  }

  @action
  Future<void> loadFavoriteCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final ids =
        prefs.getStringList('favoriteCharacters')?.map(int.parse).toList() ??
            [];
    favoriteCharacters = ObservableSet<int>.of(ids);
  }

  @action
  void addFavoriteCharacter(int id) {
    favoriteCharacters.add(id);
    saveFavoriteCharacters();
  }

  @action
  void removeFavoriteCharacter(int id) {
    favoriteCharacters.remove(id);
    saveFavoriteCharacters();
  }

  @action
  void clearCharacters() {
    characters.clear();
    currentPage = 1;
    currentPageFiltered = 1;
  }
}
