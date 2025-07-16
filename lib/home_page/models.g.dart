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
              ?.map((e) =>
                  WhiteboardElementComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WhiteboardElementComment>[],
    );

Map<String, dynamic> _$WhiteboardElementToJson(_WhiteboardElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': const NonNullableTimestampConverter().toJson(instance.date),
      'comments': instance.comments.map((e) => e.toJson()).toList(),
    };

_WhiteboardElementComment _$WhiteboardElementCommentFromJson(
        Map<String, dynamic> json) =>
    _WhiteboardElementComment(
      comment: json['comment'] as String? ?? "",
      date: const NonNullableTimestampConverter()
          .fromJson(json['date'] as Timestamp),
    );

Map<String, dynamic> _$WhiteboardElementCommentToJson(
        _WhiteboardElementComment instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'date': const NonNullableTimestampConverter().toJson(instance.date),
    };
