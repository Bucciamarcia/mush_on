// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthEvent _$HealthEventFromJson(Map<String, dynamic> json) => _HealthEvent(
      id: json['id'] as String,
      dogId: json['dogId'] as String,
      createdAt: const NonNullableTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
      lastUpdated: const NonNullableTimestampConverter()
          .fromJson(json['lastUpdated'] as Timestamp),
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      resolvedDate: const TimestampConverter()
          .fromJson(json['resolvedDate'] as Timestamp?),
      preventFromRunning: json['preventFromRunning'] as bool? ?? false,
      notes: json['notes'] as String? ?? "",
      eventType:
          $enumDecodeNullable(_$HealthEventTypeEnumMap, json['eventType']) ??
              HealthEventType.observation,
      documentIds: (json['documentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$HealthEventToJson(_HealthEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dogId': instance.dogId,
      'createdAt':
          const NonNullableTimestampConverter().toJson(instance.createdAt),
      'lastUpdated':
          const NonNullableTimestampConverter().toJson(instance.lastUpdated),
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'resolvedDate': const TimestampConverter().toJson(instance.resolvedDate),
      'preventFromRunning': instance.preventFromRunning,
      'notes': instance.notes,
      'eventType': _$HealthEventTypeEnumMap[instance.eventType]!,
      'documentIds': instance.documentIds,
    };

const _$HealthEventTypeEnumMap = {
  HealthEventType.injury: 'injury',
  HealthEventType.illness: 'illness',
  HealthEventType.vetVisit: 'vetVisit',
  HealthEventType.procedure: 'procedure',
  HealthEventType.observation: 'observation',
  HealthEventType.other: 'other',
};

_Vaccination _$VaccinationFromJson(Map<String, dynamic> json) => _Vaccination(
      id: json['id'] as String,
      dogId: json['dogId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      dateAdministered: DateTime.parse(json['dateAdministered'] as String),
      expirationDate: const TimestampConverter()
          .fromJson(json['expirationDate'] as Timestamp?),
      documentIds: (json['documentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String,
      notes: json['notes'] as String? ?? "",
      vaccinationType: json['vaccinationType'] as String,
    );

Map<String, dynamic> _$VaccinationToJson(_Vaccination instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dogId': instance.dogId,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'dateAdministered': instance.dateAdministered.toIso8601String(),
      'expirationDate':
          const TimestampConverter().toJson(instance.expirationDate),
      'documentIds': instance.documentIds,
      'name': instance.name,
      'notes': instance.notes,
      'vaccinationType': instance.vaccinationType,
    };

_HeatCycle _$HeatCycleFromJson(Map<String, dynamic> json) => _HeatCycle(
      id: json['id'] as String,
      dogId: json['dogId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      endDate:
          const TimestampConverter().fromJson(json['endDate'] as Timestamp?),
    );

Map<String, dynamic> _$HeatCycleToJson(_HeatCycle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dogId': instance.dogId,
      'startDate': instance.startDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'endDate': const TimestampConverter().toJson(instance.endDate),
    };
