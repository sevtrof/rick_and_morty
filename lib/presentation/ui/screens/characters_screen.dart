import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/domain/entity/character/gender.dart';
import 'package:rick_and_morty/domain/entity/character/status.dart';
import 'package:rick_and_morty/presentation/states/character_store.dart';
import 'package:rick_and_morty/presentation/ui/screens/character_detail_screen.dart';
import 'package:rick_and_morty/presentation/ui/widgets/dropdown_form_field.dart';
import 'package:rick_and_morty/presentation/ui/widgets/text_form_field.dart';
import 'package:rick_and_morty/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rick_and_morty/styles/dimensions.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  CharactersScreenState createState() => CharactersScreenState();
}

class CharactersScreenState extends State<CharactersScreen> {
  final CharacterStore characterStore = GetIt.I<CharacterStore>();
  final ScrollController _scrollController = ScrollController();

  late TextEditingController _nameController;
  Status? _selectedStatus;
  late TextEditingController _speciesController;
  late TextEditingController _typeController;
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    characterStore.fetchCharacters();
    characterStore.loadFavoriteCharacters();

    _scrollController.addListener(_onScroll);
    _nameController = TextEditingController();
    _speciesController = TextEditingController();
    _typeController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _speciesController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      characterStore.fetchNextPage(
        name: _nameController.text,
        status: _selectedStatus?.value ?? '',
        species: _speciesController.text,
        type: _typeController.text,
        gender: _selectedGender?.value ?? '',
      );
    }
  }

  void _openFilterDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _buildFilterDialog(),
    );

    if (result != null && result) {
      characterStore.fetchCharactersFiltered(
        name: _nameController.text,
        status: _selectedStatus?.value ?? '',
        species: _speciesController.text,
        type: _typeController.text,
        gender: _selectedGender?.value ?? '',
        clearList: true,
      );
    }
  }

  AlertDialog _buildFilterDialog() {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).filter),
      content: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              _buildNameTextField(),
              _buildStatusDropdown(),
              _buildSpeciesTextField(),
              _buildTypeTextField(),
              _buildGenderDropdown(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _resetFilters,
          child: Text(AppLocalizations.of(context).reset),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context).apply),
        ),
      ],
    );
  }

  TextFormField _buildNameTextField() {
    return textFormField(
      _nameController,
      AppLocalizations.of(context).name,
    );
  }

  DropdownFormField<Status> _buildStatusDropdown() {
    return DropdownFormField<Status>(
      value: _selectedStatus,
      onChanged: (Status? newValue) {
        setState(() {
          _selectedStatus = newValue;
        });
      },
      items: Status.values.map<DropdownMenuItem<Status>>((Status value) {
        return DropdownMenuItem<Status>(
          value: value,
          child: Text(value.value),
        );
      }).toList(),
      hintText: AppLocalizations.of(context).status,
    );
  }

  TextFormField _buildSpeciesTextField() {
    return textFormField(
      _speciesController,
      AppLocalizations.of(context).species,
    );
  }

  TextFormField _buildTypeTextField() {
    return textFormField(
      _typeController,
      AppLocalizations.of(context).type,
    );
  }

  DropdownFormField<Gender> _buildGenderDropdown() {
    return DropdownFormField<Gender>(
      value: _selectedGender,
      onChanged: (Gender? newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      items: Gender.values.map<DropdownMenuItem<Gender>>((Gender value) {
        return DropdownMenuItem<Gender>(
          value: value,
          child: Text(value.value),
        );
      }).toList(),
      hintText: AppLocalizations.of(context).gender,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                      color: Colors.white,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.RADIUS_10,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(character.image),
                        ),
                        title: Text(character.name),
                        subtitle: Text(
                          '${character.location.name}\n${AppLocalizations.of(context).status}: ${character.status}',
                        ),
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
                                characterStore
                                    .addFavoriteCharacter(character.id);
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
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _nameController.clear();
      _selectedStatus = null;
      _speciesController.clear();
      _typeController.clear();
      _selectedGender = null;
    });
  }
}
