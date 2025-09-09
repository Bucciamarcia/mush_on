// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamgroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamGroup _$TeamGroupFromJson(Map<String, dynamic> json) => _TeamGroup(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      date: const NonNullableTimestampConverter()
          .fromJson(json['date'] as Timestamp),
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String? ?? "",
      runType:
          $enumDecodeNullable(_$TeamGroupRunTypeEnumMap, json['runType']) ??
              TeamGroupRunType.unknown,
    );

Map<String, dynamic> _$TeamGroupToJson(_TeamGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': const NonNullableTimestampConverter().toJson(instance.date),
      'distance': instance.distance,
      'notes': instance.notes,
      'runType': _$TeamGroupRunTypeEnumMap[instance.runType]!,
    };

const _$TeamGroupRunTypeEnumMap = {
  TeamGroupRunType.training: 'training',
  TeamGroupRunType.race: 'race',
  TeamGroupRunType.tour: 'tour',
  TeamGroupRunType.unknown: 'unknown',
};
