import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty/presentation/states/character/character_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rick_and_morty/presentation/states/profile/user_store.dart';
import 'package:rick_and_morty/presentation/ui/screens/registration_screen.dart';
import 'package:rick_and_morty/styles/dimensions.dart';
import 'package:rick_and_morty/styles/text_styles.dart';
import 'package:share_plus/share_plus.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final UserStore _userStore = GetIt.I<UserStore>();
  final CharacterStore _characterStore = GetIt.I<CharacterStore>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return _userStore.isLoggedIn ? _buildProfileView() : _buildLoginView();
    });
  }

  Widget _buildProfileView() {
    return Scaffold(
      appBar: _buildProfileAppBar(),
      body: _buildProfileBody(),
    );
  }

  PreferredSizeWidget? _buildProfileAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).profile),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _logout,
        ),
      ],
    );
  }

  Future<void> _logout() async {
    await _userStore.logout();
    await _userStore.checkLoginStatus();
  }

  Widget _buildProfileBody() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.PADDING_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          _buildFavouriteCharactersHeader(),
          _buildFavouriteCharactersList(),
        ],
      ),
    );
  }

  Widget _buildFavouriteCharactersHeader() {
    return Text(
      AppLocalizations.of(context).favourite_characters,
      style: AppTextStyles.heading1,
    );
  }

  Widget _buildFavouriteCharactersList() {
    return FutureBuilder(
      future: _characterStore.fetchCharactersByIds(
          _characterStore.favouriteCharacters.toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Observer(
            builder: (_) => Expanded(
              child: ListView.builder(
                itemCount: _characterStore.favouriteCharacters.length,
                itemBuilder: (context, index) {
                  return _buildCharacterTile(index);
                },
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCharacterTile(int index) {
    final favouriteCharacterId =
        _characterStore.favouriteCharacters.elementAt(index);
    final favouriteCharacter = _characterStore.characters
        .firstWhere((character) => character.id == favouriteCharacterId);

    return Dismissible(
      key: Key(favouriteCharacterId.toString()),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        _characterStore.removeFavouriteCharacter(favouriteCharacterId);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(favouriteCharacter.image),
        ),
        title: Text(favouriteCharacter.name),
        subtitle: Text(favouriteCharacter.location.name),
        trailing: IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            Share.share(AppLocalizations.of(context).share_checkout +
                favouriteCharacter.name);
          },
        ),
      ),
    );
  }

  Widget _buildLoginView() {
    return Scaffold(
      appBar: _buildLoginAppBar(),
      body: Center(child: _buildLoginForm(context)),
    );
  }

  PreferredSizeWidget? _buildLoginAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).profile),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.PADDING_20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context).email),
          ),
          const SizedBox(height: AppDimensions.ITEM_HEIGHT_10),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).password),
            obscureText: true,
          ),
          const SizedBox(height: AppDimensions.ITEM_HEIGHT_20),
          ElevatedButton(
            onPressed: _performLogin,
            child: Text(AppLocalizations.of(context).login),
          ),
          const SizedBox(height: AppDimensions.ITEM_HEIGHT_10),
          ElevatedButton(
            onPressed: _navigateToRegistration,
            child: Text(AppLocalizations.of(context).register),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogin() async {
    await _userStore.login(
      _emailController.text,
      _passwordController.text,
    );
    if (_userStore.isLoggedIn) {
      await _characterStore.fetchFavouriteCharacters();
      await _characterStore.fetchCharacters();
    }
  }

  void _navigateToRegistration() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_userStore.user.profilePicture.isNotEmpty)
          CircleAvatar(
            backgroundImage: NetworkImage(_userStore.user.profilePicture),
            radius: AppDimensions.RADIUS_60,
          ),
        const SizedBox(height: AppDimensions.ITEM_HEIGHT_8),
        Text(
          _userStore.user.name,
          style: AppTextStyles.heading1
        ),
        const SizedBox(height: AppDimensions.ITEM_HEIGHT_4),
        Text(
          _userStore.user.email,
          style: AppTextStyles.bodyText
        ),
        const SizedBox(height: AppDimensions.ITEM_HEIGHT_16),
      ],
    );
  }

}
