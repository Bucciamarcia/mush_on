// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dog _$DogFromJson(Map<String, dynamic> json) => Dog(
      name: json['name'] as String? ?? "",
      positions: (json['positions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {"lead": false, "swing": false, "team": false, "wheel": false},
    );

Map<String, dynamic> _$DogToJson(Dog instance) => <String, dynamic>{
      'name': instance.name,
      'positions': instance.positions,
    };
