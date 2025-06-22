// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamgroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamGroup _$TeamGroupFromJson(Map<String, dynamic> json) => _TeamGroup(
      name: json['name'] as String? ?? "",
      date: const NonNullableTimestampConverter()
          .fromJson(json['date'] as Timestamp),
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String? ?? "",
      teams: json['teams'] == null
          ? const []
          : _teamsFromJson(json['teams'] as List?),
    );

Map<String, dynamic> _$TeamGroupToJson(_TeamGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': const NonNullableTimestampConverter().toJson(instance.date),
      'distance': instance.distance,
      'notes': instance.notes,
      'teams': _teamsToJson(instance.teams),
    };
