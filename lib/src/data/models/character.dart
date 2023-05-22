import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {
  final String name;
  final String image;

  Character(this.name, this.image);

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
