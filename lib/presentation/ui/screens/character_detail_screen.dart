import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/presentation/states/character_detail_store.dart';
import 'package:rick_and_morty/styles/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CharacterDetailScreen extends StatefulWidget {
  final int characterId;

  const CharacterDetailScreen({super.key, required this.characterId});

  @override
  CharacterDetailScreenState createState() => CharacterDetailScreenState();
}

class CharacterDetailScreenState extends State<CharacterDetailScreen> {
  final CharacterDetailStore _characterDetailStore =
      GetIt.I<CharacterDetailStore>();

  @override
  void initState() {
    super.initState();
    _characterDetailStore.fetchCharacterDetail(widget.characterId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).characterDetails),
        ),
        body: Observer(
          builder: (_) {
            if (_characterDetailStore.selectedCharacter != null) {
              final character = _characterDetailStore.selectedCharacter!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: character.id,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(character.image),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        character.name,
                        style: AppTextStyles.heading1,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        '${AppLocalizations.of(context).status}: ${character.status}',
                        style: AppTextStyles.bodyText,
                      ),
                      Text(
                        '${AppLocalizations.of(context).species}: ${character.species}',
                        style: AppTextStyles.bodyText,
                      ),
                      Text(
                        '${AppLocalizations.of(context).type}: ${character.type}',
                        style: AppTextStyles.bodyText,
                      ),
                      Text(
                        '${AppLocalizations.of(context).gender}: ${character.gender}',
                        style: AppTextStyles.bodyText,
                      ),
                      Text(
                        '${AppLocalizations.of(context).origin}: ${character.origin.name}',
                        style: AppTextStyles.bodyText,
                      ),
                      Text(
                        '${AppLocalizations.of(context).location}: ${character.location.name}',
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 16.0),
                      ExpansionTile(
                        title: Text(
                          AppLocalizations.of(context).episodes,
                          style: AppTextStyles.heading2,
                        ),
                        children: character.episode.map((episode) {
                          return ListTile(
                            title: Text(
                              episode,
                              style: AppTextStyles.bodyText,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else if (_characterDetailStore.error != null) {
              return Center(
                child: Text(
                  _characterDetailStore.error!,
                  style: AppTextStyles.bodyText,
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    ]);
  }
}
