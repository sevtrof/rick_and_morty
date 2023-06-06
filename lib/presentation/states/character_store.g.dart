// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CharacterStore on CharacterStoreBase, Store {
  late final _$charactersAtom =
      Atom(name: 'CharacterStoreBase.characters', context: context);

  @override
  ObservableList<Character> get characters {
    _$charactersAtom.reportRead();
    return super.characters;
  }

  @override
  set characters(ObservableList<Character> value) {
    _$charactersAtom.reportWrite(value, super.characters, () {
      super.characters = value;
    });
  }

  late final _$favoriteCharactersAtom =
      Atom(name: 'CharacterStoreBase.favoriteCharacters', context: context);

  @override
  ObservableSet<int> get favoriteCharacters {
    _$favoriteCharactersAtom.reportRead();
    return super.favoriteCharacters;
  }

  @override
  set favoriteCharacters(ObservableSet<int> value) {
    _$favoriteCharactersAtom.reportWrite(value, super.favoriteCharacters, () {
      super.favoriteCharacters = value;
    });
  }

  late final _$selectedCharacterAtom =
      Atom(name: 'CharacterStoreBase.selectedCharacter', context: context);

  @override
  Character? get selectedCharacter {
    _$selectedCharacterAtom.reportRead();
    return super.selectedCharacter;
  }

  @override
  set selectedCharacter(Character? value) {
    _$selectedCharacterAtom.reportWrite(value, super.selectedCharacter, () {
      super.selectedCharacter = value;
    });
  }

  late final _$errorAtom =
      Atom(name: 'CharacterStoreBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$currentPageAtom =
      Atom(name: 'CharacterStoreBase.currentPage', context: context);

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$currentPageFilteredAtom =
      Atom(name: 'CharacterStoreBase.currentPageFiltered', context: context);

  @override
  int get currentPageFiltered {
    _$currentPageFilteredAtom.reportRead();
    return super.currentPageFiltered;
  }

  @override
  set currentPageFiltered(int value) {
    _$currentPageFilteredAtom.reportWrite(value, super.currentPageFiltered, () {
      super.currentPageFiltered = value;
    });
  }

  late final _$fetchCharactersAsyncAction =
      AsyncAction('CharacterStoreBase.fetchCharacters', context: context);

  @override
  Future<void> fetchCharacters() {
    return _$fetchCharactersAsyncAction.run(() => super.fetchCharacters());
  }

  late final _$fetchCharactersFilteredAsyncAction = AsyncAction(
      'CharacterStoreBase.fetchCharactersFiltered',
      context: context);

  @override
  Future<void> fetchCharactersFiltered(
      {String? name,
      String? status,
      String? species,
      String? type,
      String? gender,
      bool clearList = false}) {
    return _$fetchCharactersFilteredAsyncAction.run(() => super
        .fetchCharactersFiltered(
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            clearList: clearList));
  }

  late final _$saveFavoriteCharactersAsyncAction = AsyncAction(
      'CharacterStoreBase.saveFavoriteCharacters',
      context: context);

  @override
  Future<void> saveFavoriteCharacters() {
    return _$saveFavoriteCharactersAsyncAction
        .run(() => super.saveFavoriteCharacters());
  }

  late final _$loadFavoriteCharactersAsyncAction = AsyncAction(
      'CharacterStoreBase.loadFavoriteCharacters',
      context: context);

  @override
  Future<void> loadFavoriteCharacters() {
    return _$loadFavoriteCharactersAsyncAction
        .run(() => super.loadFavoriteCharacters());
  }

  late final _$CharacterStoreBaseActionController =
      ActionController(name: 'CharacterStoreBase', context: context);

  @override
  void addFavoriteCharacter(int id) {
    final _$actionInfo = _$CharacterStoreBaseActionController.startAction(
        name: 'CharacterStoreBase.addFavoriteCharacter');
    try {
      return super.addFavoriteCharacter(id);
    } finally {
      _$CharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFavoriteCharacter(int id) {
    final _$actionInfo = _$CharacterStoreBaseActionController.startAction(
        name: 'CharacterStoreBase.removeFavoriteCharacter');
    try {
      return super.removeFavoriteCharacter(id);
    } finally {
      _$CharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCharacters() {
    final _$actionInfo = _$CharacterStoreBaseActionController.startAction(
        name: 'CharacterStoreBase.clearCharacters');
    try {
      return super.clearCharacters();
    } finally {
      _$CharacterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
characters: ${characters},
favoriteCharacters: ${favoriteCharacters},
selectedCharacter: ${selectedCharacter},
error: ${error},
currentPage: ${currentPage},
currentPageFiltered: ${currentPageFiltered}
    ''';
  }
}
