import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/domain/entity/character/gender.dart';
import 'package:rick_and_morty/domain/entity/character/status.dart';
import 'package:rick_and_morty/presentation/states/character_store.dart';
import 'package:rick_and_morty/presentation/ui/screens/character_detail_screen.dart';
import 'package:rick_and_morty/presentation/ui/widgets/dropdown_button.dart';
import 'package:rick_and_morty/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  CharactersScreenState createState() => CharactersScreenState();
}

class CharactersScreenState extends State<CharactersScreen> {
  final CharacterStore characterStore = GetIt.I<CharacterStore>();
  final ScrollController _scrollController = ScrollController();

  String _filterName = '';
  Status _filterStatus = Status.empty;
  String _filterSpecies = '';
  String _filterType = '';
  Gender _filterGender = Gender.empty;

  @override
  void initState() {
    super.initState();
    characterStore.fetchCharacters();
    characterStore.loadFavoriteCharacters();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_filterName.isNotEmpty ||
          _filterStatus != Status.empty ||
          _filterSpecies.isNotEmpty ||
          _filterType.isNotEmpty ||
          _filterGender != Gender.empty) {
        characterStore.fetchCharactersFiltered(
          name: _filterName,
          status: _filterStatus.value,
          species: _filterSpecies,
          type: _filterType,
          gender: _filterGender.value,
        );
      } else {
        characterStore.fetchCharacters();
      }
    }
  }

  void _openFilterDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).filter),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      _filterName = value;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).name,
                    ),
                  ),
                  dropdownButton<Status>(
                    _filterStatus,
                    (Status? newValue) {
                      setState(() {
                        _filterStatus = newValue ?? Status.empty;
                      });
                    },
                    Status.values.map<DropdownMenuItem<Status>>((Status value) {
                      return DropdownMenuItem<Status>(
                        value: value,
                        child: Text(value.value),
                      );
                    }).toList(),
                    (BuildContext context) {
                      return Status.values.map<Widget>((Status value) {
                        return Text(_filterStatus.value);
                      }).toList();
                    },
                  ),
                  TextField(
                    onChanged: (value) {
                      _filterSpecies = value;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).species,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      _filterType = value;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).type,
                    ),
                  ),
                  dropdownButton<Gender>(
                    _filterGender,
                    (Gender? newValue) {
                      setState(() {
                        _filterGender = newValue ?? Gender.empty;
                      });
                    },
                    Gender.values.map<DropdownMenuItem<Gender>>((Gender value) {
                      return DropdownMenuItem<Gender>(
                        value: value,
                        child: Text(value.value),
                      );
                    }).toList(),
                    (BuildContext context) {
                      return Gender.values.map<Widget>((Gender value) {
                        return Text(_filterGender.value);
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  characterStore.fetchCharactersFiltered(
                    name: _filterName,
                    status: _filterStatus.value,
                    species: _filterSpecies,
                    type: _filterType,
                    gender: _filterGender.value,
                    clearList: true,
                  );
                },
                child: Text(AppLocalizations.of(context).apply),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets/images/characters_background.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).characters),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _openFilterDialog,
            ),
          ],
        ),
        body: Observer(
          builder: (_) {
            if (characterStore.characters.isNotEmpty) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: characterStore.characters.length,
                itemBuilder: (context, index) {
                  final character = characterStore.characters[index];
                  return Card(
                    // Added Card
                    color: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(character.image),
                      ),
                      title: Text(character.name),
                      subtitle: Text(
                          '${character.location.name}\n${AppLocalizations.of(context).status}: ${character.status}'),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterDetailScreen(
                              characterId: character.id,
                            ),
                          ),
                        );
                      },
                      trailing: Observer(
                        builder: (_) => IconButton(
                          icon: Icon(
                            characterStore.favoriteCharacters
                                    .contains(character.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          onPressed: () {
                            if (characterStore.favoriteCharacters
                                .contains(character.id)) {
                              characterStore
                                  .removeFavoriteCharacter(character.id);
                            } else {
                              characterStore.addFavoriteCharacter(character.id);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (characterStore.error != null) {
              return Center(child: Text(characterStore.error!));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    ]);
  }
}
