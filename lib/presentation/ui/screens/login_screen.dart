import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rick_and_morty/presentation/states/profile/login_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rick_and_morty/presentation/ui/screens/registration_screen.dart';
import 'package:rick_and_morty/styles/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final LoginStore _profileStore = GetIt.I<LoginStore>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileStore.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).profile),
      ),
      body: Observer(
        builder: (_) => Center(
          child: _profileStore.isLoggedIn
              ? _buildLoggedInWidget()
              : _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoggedInWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context).loggedIn),
        const SizedBox(height: AppDimensions.ITEM_HEIGHT_20),
        ElevatedButton(
          onPressed: () => _profileStore.logout(),
          child: Text(AppLocalizations.of(context).logout),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
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
            onPressed: () => _profileStore.login(
              _emailController.text,
              _passwordController.text,
            ),
            child: Text(AppLocalizations.of(context).login),
          ),
          const SizedBox(height: AppDimensions.ITEM_HEIGHT_10),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RegistrationScreen(),
              ),
            ),
            child: Text(AppLocalizations.of(context).register),
          ),
        ],
      ),
    );
  }
}
