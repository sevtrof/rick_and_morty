import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:rick_and_morty/domain/entity/character/character.dart';
import 'package:rick_and_morty/domain/entity/location/location.dart';
import 'package:rick_and_morty/domain/entity/origin/origin.dart';
import 'package:rick_and_morty/presentation/ui/screens/characters_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/presentation/states/character/character_store.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MockCharacterStore extends Mock implements CharacterStore {
  @override
  mobx.ObservableList<Character> get characters => mobx.ObservableList<Character>.of([
        const Character(
          id: 1,
          name: 'Rick Sanchez',
          status: 'Alive',
          species: 'Human',
          type: '',
          gender: 'Male',
          origin: Origin(
              name: 'Earth', url: 'https://rickandmortyapi.com/api/location/1'),
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
        )
      ]);

  @override
  mobx.ObservableSet<int> get favoriteCharacters => mobx.ObservableSet<int>.of([]);

  @override
  Future<void> loadFavoriteCharacters() async {
    await Future.delayed(const Duration(seconds: 1));
    return Future.value();
  }

  @override
  Future<void> fetchCharacters() async {
    await Future.delayed(const Duration(seconds: 1));
    return Future.value();
  }
}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    getIt.registerSingleton<CharacterStore>(MockCharacterStore());
  });

  tearDownAll(() {
    getIt.unregister<CharacterStore>();
  });

  testWidgets('CharactersScreen widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CharactersScreen(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CharactersScreen), findsOneWidget);
  });
}
