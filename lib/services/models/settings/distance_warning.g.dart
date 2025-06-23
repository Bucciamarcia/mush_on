// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_warning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DistanceWarning _$DistanceWarningFromJson(Map<String, dynamic> json) =>
    _DistanceWarning(
      distance: (json['distance'] as num?)?.toInt() ?? 0,
      distanceWarningType:
          json['distanceWarningType'] ?? DistanceWarningType.soft,
    );

Map<String, dynamic> _$DistanceWarningToJson(_DistanceWarning instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'distanceWarningType': instance.distanceWarningType,
    };
