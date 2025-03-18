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

TeamGroup _$TeamGroupFromJson(Map<String, dynamic> json) => TeamGroup(
      name: json['name'] as String? ?? "",
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? "",
      teams: (json['teams'] as List<dynamic>?)
              ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TeamGroupToJson(TeamGroup instance) => <String, dynamic>{
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'notes': instance.notes,
      'teams': instance.teams,
    };

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      name: json['name'] as String? ?? "",
      dogPairs: (json['dogPairs'] as List<dynamic>?)
              ?.map((e) => DogPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'name': instance.name,
      'dogPairs': instance.dogPairs,
    };

DogPair _$DogPairFromJson(Map<String, dynamic> json) => DogPair(
      firstDog: json['firstDog'] == null
          ? null
          : Dog.fromJson(json['firstDog'] as Map<String, dynamic>),
      secondDog: json['secondDog'] == null
          ? null
          : Dog.fromJson(json['secondDog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DogPairToJson(DogPair instance) => <String, dynamic>{
      'firstDog': instance.firstDog,
      'secondDog': instance.secondDog,
    };
