// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Dog _$DogFromJson(Map<String, dynamic> json) => _Dog(
      name: json['name'] as String? ?? "",
      sex: $enumDecodeNullable(_$DogSexEnumMap, json['sex']) ?? DogSex.none,
      id: json['id'] as String? ?? "",
      positions: json['positions'] == null
          ? const DogPositions()
          : DogPositions.fromJson(json['positions'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      customFields: (json['customFields'] as List<dynamic>?)
              ?.map((e) => CustomField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => SingleDogNote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      distanceWarnings: (json['distanceWarnings'] as List<dynamic>?)
              ?.map((e) => DistanceWarning.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      birth: const TimestampConverter().fromJson(json['birth'] as Timestamp?),
    );

Map<String, dynamic> _$DogToJson(_Dog instance) => <String, dynamic>{
      'name': instance.name,
      'sex': _$DogSexEnumMap[instance.sex]!,
      'id': instance.id,
      'positions': instance.positions.toJson(),
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'customFields': instance.customFields.map((e) => e.toJson()).toList(),
      'notes': instance.notes.map((e) => e.toJson()).toList(),
      'distanceWarnings':
          instance.distanceWarnings.map((e) => e.toJson()).toList(),
      'birth': const TimestampConverter().toJson(instance.birth),
    };

const _$DogSexEnumMap = {
  DogSex.male: 'male',
  DogSex.female: 'female',
  DogSex.none: 'none',
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
      preventFromRun: json['preventFromRun'] as bool? ?? false,
      showInTeamBuilder: json['showInTeamBuilder'] as bool? ?? false,
      created: DateTime.parse(json['created'] as String),
      color: json['color'] == null
          ? Colors.green
          : const ColorConverter().fromJson((json['color'] as num).toInt()),
      expired:
          const TimestampConverter().fromJson(json['expired'] as Timestamp?),
    );

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'preventFromRun': instance.preventFromRun,
      'showInTeamBuilder': instance.showInTeamBuilder,
      'created': instance.created.toIso8601String(),
      'color': const ColorConverter().toJson(instance.color),
      'expired': const TimestampConverter().toJson(instance.expired),
    };
