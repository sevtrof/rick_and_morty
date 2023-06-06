import 'package:rick_and_morty/data/model/character/character.dart' as data;
import 'package:rick_and_morty/domain/entity/character/character.dart'
    as domain;
import 'package:rick_and_morty/domain/entity/location/location_ext.dart';
import 'package:rick_and_morty/domain/entity/origin/origin_ext.dart';

extension CharacterDataExtension on data.Character {
  domain.Character toDomain() {
    return domain.Character(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      origin: origin.toDomain(),
      location: location.toDomain(),
      image: image,
      episode: episode,
      url: url,
      created: created,
    );
  }
}
