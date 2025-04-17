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
      pictureUrl: json['pictureUrl'] as String? ?? "",
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DogToJson(_Dog instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'positions': instance.positions.toJson(),
      'pictureUrl': instance.pictureUrl,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
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

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      created: DateTime.parse(json['created'] as String),
      color: json['color'] == null
          ? Colors.green
          : const ColorConverter().fromJson((json['color'] as num).toInt()),
      expired: json['expired'] == null
          ? null
          : DateTime.parse(json['expired'] as String),
    );

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created': instance.created.toIso8601String(),
      'color': const ColorConverter().toJson(instance.color),
      'expired': instance.expired?.toIso8601String(),
    };
