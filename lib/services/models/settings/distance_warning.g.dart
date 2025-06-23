// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_warning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DistanceWarning _$DistanceWarningFromJson(Map<String, dynamic> json) =>
    _DistanceWarning(
      id: json['id'] as String? ?? "",
      daysInterval: (json['daysInterval'] as num?)?.toInt() ?? 9,
      distance: (json['distance'] as num?)?.toInt() ?? 0,
      distanceWarningType: $enumDecodeNullable(
              _$DistanceWarningTypeEnumMap, json['distanceWarningType']) ??
          DistanceWarningType.soft,
    );

Map<String, dynamic> _$DistanceWarningToJson(_DistanceWarning instance) =>
    <String, dynamic>{
      'id': instance.id,
      'daysInterval': instance.daysInterval,
      'distance': instance.distance,
      'distanceWarningType':
          _$DistanceWarningTypeEnumMap[instance.distanceWarningType]!,
    };

const _$DistanceWarningTypeEnumMap = {
  DistanceWarningType.soft: 'soft',
  DistanceWarningType.hard: 'hard',
};
