// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SingleDogNote _$SingleDogNoteFromJson(Map<String, dynamic> json) =>
    _SingleDogNote(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      id: json['id'] as String? ?? "",
      content: json['content'] as String? ?? "",
    );

Map<String, dynamic> _$SingleDogNoteToJson(_SingleDogNote instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'id': instance.id,
      'content': instance.content,
    };
