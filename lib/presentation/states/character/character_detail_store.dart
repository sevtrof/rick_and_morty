import 'package:mobx/mobx.dart';
import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/domain/usecase/characters/get_character_detail_usecase.dart';

part 'character_detail_store.g.dart';

class CharacterDetailStore = CharacterDetailStoreBase with _$CharacterDetailStore;

abstract class CharacterDetailStoreBase with Store {
  final GetCharacterDetailUseCase getCharacterDetailUseCase;

  CharacterDetailStoreBase({required this.getCharacterDetailUseCase});

  @observable
  Character? selectedCharacter;

  @observable
  String? error;

  @action
  Future<void> fetchCharacterDetail(int id) async {
    final result = await getCharacterDetailUseCase.call(id);
    selectedCharacter = result;
  }
}
