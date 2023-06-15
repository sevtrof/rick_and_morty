import 'package:isar/isar.dart';

part 'isar_character.g.dart';

@Collection()
class CharacterIsar {
  Id? id;

  @Index()
  late String name;

  late String status;
  late String species;
  late String type;
  late String gender;

  late String origin;
  late String location;

  late String image;
  late String episode;
  late String url;
  late String created;
}
