import 'package:rick_and_morty/data/model/character/character.dart';

class Info {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  Info({required this.count, required this.pages, this.next, this.prev});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'],
      pages: json['pages'],
      next: json['next'],
      prev: json['prev'],
    );
  }
}

class CharacterListResponse {
  final Info info;
  final List<Character> results;

  CharacterListResponse({required this.info, required this.results});

  factory CharacterListResponse.fromJson(Map<String, dynamic> json) {
    return CharacterListResponse(
      info: Info.fromJson(json['info']),
      results: (json['results'] as List)
          .map((i) => Character.fromJson(i))
          .toList(),
    );
  }
}
