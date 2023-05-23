// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      json['id'] as int,
      json['name'] as String,
      json['status'] as String,
      json['species'] as String,
      json['type'] as String,
      json['gender'] as String,
      json['image'] as String,
      json['url'] as String,
      json['created'] as String,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
    };
