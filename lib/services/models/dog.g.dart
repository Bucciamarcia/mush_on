// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Dog _$DogFromJson(Map<String, dynamic> json) => _Dog(
      name: json['name'] as String? ?? "",
      id: json['id'] as String? ?? "",
      positions: json['positions'] == null
          ? const DogPositions()
          : DogPositions.fromJson(json['positions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DogToJson(_Dog instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'positions': instance.positions,
    };

_DogPositions _$DogPositionsFromJson(Map<String, dynamic> json) =>
    _DogPositions(
      lead: json['lead'] as bool? ?? false,
      swing: json['swing'] as bool? ?? false,
      team: json['team'] as bool? ?? false,
      wheel: json['wheel'] as bool? ?? false,
    );

Map<String, dynamic> _$DogPositionsToJson(_DogPositions instance) =>
    <String, dynamic>{
      'lead': instance.lead,
      'swing': instance.swing,
      'team': instance.team,
      'wheel': instance.wheel,
    };
