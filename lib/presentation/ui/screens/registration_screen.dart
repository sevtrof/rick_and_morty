import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rick_and_morty/presentation/states/profile/registration_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rick_and_morty/styles/dimensions.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationStore _registrationStore = GetIt.I<RegistrationStore>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).register),
      ),
      body: Observer(
        builder: (_) => Padding(
          padding: const EdgeInsets.all(AppDimensions.PADDING_20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).username),
              ),
              const SizedBox(height: AppDimensions.ITEM_HEIGHT_10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).email),
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
                onPressed: () async {
                  await _registrationStore.register(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    () => Navigator.of(context).pop(),
                  );
                },
                child: Text(AppLocalizations.of(context).register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
