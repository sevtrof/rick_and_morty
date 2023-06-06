import 'package:flutter/material.dart';
import 'package:rick_and_morty/di/di.dart';
import 'package:rick_and_morty/presentation/ui/screens/characters_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Rick and Morty app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CharactersScreen(),
    );
  }
}
