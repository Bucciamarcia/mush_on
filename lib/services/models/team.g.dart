// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Team _$TeamFromJson(Map<String, dynamic> json) => _Team(
      name: json['name'] as String? ?? "",
      id: json['id'] as String,
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'rank': instance.rank,
    };
