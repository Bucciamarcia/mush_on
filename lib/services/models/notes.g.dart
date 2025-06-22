// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SingleDogNote _$SingleDogNoteFromJson(Map<String, dynamic> json) =>
    _SingleDogNote(
      date: const TimestampConverter().fromJson(json['date'] as Timestamp?),
      id: json['id'] as String? ?? "",
      content: json['content'] as String? ?? "",
    );

Map<String, dynamic> _$SingleDogNoteToJson(_SingleDogNote instance) =>
    <String, dynamic>{
      'date': const TimestampConverter().toJson(instance.date),
      'id': instance.id,
      'content': instance.content,
    };
