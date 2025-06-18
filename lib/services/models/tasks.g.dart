// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
      id: json['id'] as String? ?? "",
      title: json['title'] as String? ?? "",
      description: json['description'] as String? ?? "",
      expiration: json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String),
      isDone: json['isDone'] ?? false,
      dogId: json['dogId'] as String?,
    );

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'expiration': instance.expiration?.toIso8601String(),
      'isDone': instance.isDone,
      'dogId': instance.dogId,
    };
