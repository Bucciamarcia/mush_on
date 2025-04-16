// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamgroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamGroup _$TeamGroupFromJson(Map<String, dynamic> json) => TeamGroup(
      name: json['name'] as String? ?? "",
      date: TeamGroup._dateFromTimestamp(json['date']),
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String? ?? "",
      teams: json['teams'] == null
          ? const []
          : TeamGroup._teamsFromJson(json['teams'] as List?),
    );

Map<String, dynamic> _$TeamGroupToJson(TeamGroup instance) => <String, dynamic>{
      'name': instance.name,
      'date': TeamGroup._dateToTimestamp(instance.date),
      'distance': instance.distance,
      'notes': instance.notes,
      'teams': TeamGroup._teamsToJson(instance.teams),
    };
