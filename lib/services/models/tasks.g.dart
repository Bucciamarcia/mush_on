// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
      id: json['id'] as String? ?? "",
      title: json['title'] as String? ?? "",
      description: json['description'] as String? ?? "",
      expiration:
          const TimestampConverter().fromJson(json['expiration'] as Timestamp?),
      isDone: json['isDone'] as bool? ?? false,
      isAllDay: json['isAllDay'] as bool? ?? true,
      isUrgent: json['isUrgent'] as bool? ?? false,
      recurring:
          $enumDecodeNullable(_$RecurringTypeEnumMap, json['recurring']) ??
              RecurringType.none,
      recurringDone: json['recurringDone'] == null
          ? const <DateTime>[]
          : const TimestampListConverter()
              .fromJson(json['recurringDone'] as List),
      dogId: json['dogId'] as String?,
    );

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'expiration': const TimestampConverter().toJson(instance.expiration),
      'isDone': instance.isDone,
      'isAllDay': instance.isAllDay,
      'isUrgent': instance.isUrgent,
      'recurring': _$RecurringTypeEnumMap[instance.recurring]!,
      'recurringDone':
          const TimestampListConverter().toJson(instance.recurringDone),
      'dogId': instance.dogId,
    };

const _$RecurringTypeEnumMap = {
  RecurringType.daily: 'daily',
  RecurringType.weekly: 'weekly',
  RecurringType.monthly: 'monthly',
  RecurringType.yearly: 'yearly',
  RecurringType.none: 'none',
};
