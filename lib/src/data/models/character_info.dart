import 'character.dart';

class CharacterInfo {
  int? count;
  int? pages;
  String? next;
  String? prev;
  List<Character>? characters;

  CharacterInfo({
    this.count,
    this.pages,
    this.next,
    this.prev,
    this.characters,
  });

  CharacterInfo.fromJson(Map<String, dynamic> json) {
    count = json['info']['count'];
    pages = json['info']['pages'];
    next = json['info']['next'];
    prev = json['info']['prev'];
    if (json['results'] != null) {
      characters = [];
      json['results'].forEach((v) {
        characters!.add(Character.fromJson(v));
      });
    }
  }
}
