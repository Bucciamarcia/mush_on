// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Team _$TeamFromJson(Map<String, dynamic> json) => _Team(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      dogPairs: (json['dogPairs'] as List<dynamic>?)
              ?.map((e) => DogPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TeamToJson(_Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dogPairs': instance.dogPairs,
    };
