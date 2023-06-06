// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CharacterDetailStore on CharacterDetailStoreBase, Store {
  late final _$selectedCharacterAtom = Atom(
      name: 'CharacterDetailStoreBase.selectedCharacter', context: context);

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
      Atom(name: 'CharacterDetailStoreBase.error', context: context);

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

  late final _$fetchCharacterDetailAsyncAction = AsyncAction(
      'CharacterDetailStoreBase.fetchCharacterDetail',
      context: context);

  @override
  Future<void> fetchCharacterDetail(int id) {
    return _$fetchCharacterDetailAsyncAction
        .run(() => super.fetchCharacterDetail(id));
  }

  @override
  String toString() {
    return '''
selectedCharacter: ${selectedCharacter},
error: ${error}
    ''';
  }
}
