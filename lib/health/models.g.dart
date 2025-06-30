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
      createdAt: const NonNullableTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
      lastUpdated: const NonNullableTimestampConverter()
          .fromJson(json['lastUpdated'] as Timestamp),
      dateAdministered: const NonNullableTimestampConverter()
          .fromJson(json['dateAdministered'] as Timestamp),
      expirationDate: const TimestampConverter()
          .fromJson(json['expirationDate'] as Timestamp?),
      documentIds: (json['documentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      title: json['title'] as String,
      notes: json['notes'] as String? ?? "",
      vaccinationType: json['vaccinationType'] as String,
    );

Map<String, dynamic> _$VaccinationToJson(_Vaccination instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dogId': instance.dogId,
      'createdAt':
          const NonNullableTimestampConverter().toJson(instance.createdAt),
      'lastUpdated':
          const NonNullableTimestampConverter().toJson(instance.lastUpdated),
      'dateAdministered': const NonNullableTimestampConverter()
          .toJson(instance.dateAdministered),
      'expirationDate':
          const TimestampConverter().toJson(instance.expirationDate),
      'documentIds': instance.documentIds,
      'title': instance.title,
      'notes': instance.notes,
      'vaccinationType': instance.vaccinationType,
    };

_HeatCycle _$HeatCycleFromJson(Map<String, dynamic> json) => _HeatCycle(
      id: json['id'] as String,
      dogId: json['dogId'] as String,
      notes: json['notes'] as String? ?? "",
      startDate: const NonNullableTimestampConverter()
          .fromJson(json['startDate'] as Timestamp),
      createdAt: const NonNullableTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
      lastUpdated: const NonNullableTimestampConverter()
          .fromJson(json['lastUpdated'] as Timestamp),
      preventFromRunning: json['preventFromRunning'] as bool? ?? false,
      endDate:
          const TimestampConverter().fromJson(json['endDate'] as Timestamp?),
    );

Map<String, dynamic> _$HeatCycleToJson(_HeatCycle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dogId': instance.dogId,
      'notes': instance.notes,
      'startDate':
          const NonNullableTimestampConverter().toJson(instance.startDate),
      'createdAt':
          const NonNullableTimestampConverter().toJson(instance.createdAt),
      'lastUpdated':
          const NonNullableTimestampConverter().toJson(instance.lastUpdated),
      'preventFromRunning': instance.preventFromRunning,
      'endDate': const TimestampConverter().toJson(instance.endDate),
    };
