// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamGroup _$TeamGroupFromJson(Map<String, dynamic> json) => TeamGroup(
      name: json['name'] as String? ?? "",
      date: TeamGroup._dateFromTimestamp(json['date']),
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String? ?? "",
      teams: json['teams'] == null
          ? const []
          : TeamGroup._teamsFromJson(json['teams'] as List?),
    );

Map<String, dynamic> _$TeamGroupToJson(TeamGroup instance) => <String, dynamic>{
      'name': instance.name,
      'date': TeamGroup._dateToTimestamp(instance.date),
      'distance': instance.distance,
      'notes': instance.notes,
      'teams': TeamGroup._teamsToJson(instance.teams),
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
      firstDogId: json['firstDogId'] as String?,
      secondDogId: json['secondDogId'] as String?,
    );

Map<String, dynamic> _$DogPairToJson(DogPair instance) => <String, dynamic>{
      'firstDogId': instance.firstDogId,
      'secondDogId': instance.secondDogId,
    };

Dog _$DogFromJson(Map<String, dynamic> json) => Dog(
      name: json['name'] as String? ?? "",
      id: json['id'] as String? ?? "",
      positions: json['positions'] == null
          ? null
          : DogPositions.fromJson(json['positions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DogToJson(Dog instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'positions': instance.positions,
    };

DogPositions _$DogPositionsFromJson(Map<String, dynamic> json) => DogPositions(
      lead: json['lead'] as bool? ?? false,
      swing: json['swing'] as bool? ?? false,
      team: json['team'] as bool? ?? false,
      wheel: json['wheel'] as bool? ?? false,
    );

Map<String, dynamic> _$DogPositionsToJson(DogPositions instance) =>
    <String, dynamic>{
      'lead': instance.lead,
      'swing': instance.swing,
      'team': instance.team,
      'wheel': instance.wheel,
    };

UserName _$UserNameFromJson(Map<String, dynamic> json) => UserName(
      lastLogin: UserName._timestampToDateTime(json['last_login']),
      account: json['account'] as String?,
    );

Map<String, dynamic> _$UserNameToJson(UserName instance) => <String, dynamic>{
      'last_login': instance.lastLogin.toIso8601String(),
      'account': instance.account,
    };
