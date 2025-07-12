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
      date: const NonNullableTimestampConverter()
          .fromJson(json['date'] as Timestamp),
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
      'date': const NonNullableTimestampConverter().toJson(instance.date),
      'comments': instance.comments,
    };
