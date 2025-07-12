// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WhiteboardElement _$WhiteboardElementFromJson(Map<String, dynamic> json) =>
    _WhiteboardElement(
      id: json['id'] as String,
      title: json['title'] as String? ?? "",
      description: json['description'] as String? ?? "",
      date: DateTime.parse(json['date'] as String),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$WhiteboardElementToJson(_WhiteboardElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'comments': instance.comments,
    };
