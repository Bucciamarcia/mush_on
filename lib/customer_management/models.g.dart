// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      name: json['name'] as String? ?? "",
      email: json['email'] as String?,
      age: (json['age'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toInt(),
      teamId: json['teamId'] as String?,
      pricingId: json['pricingId'] as String?,
    );

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'name': instance.name,
      'email': instance.email,
      'age': instance.age,
      'weight': instance.weight,
      'teamId': instance.teamId,
      'pricingId': instance.pricingId,
    };

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
      id: json['id'] as String,
      name: json['name'] as String? ?? "",
      date: const NonNullableTimestampConverter()
          .fromJson(json['date'] as Timestamp),
      customerGroupId: json['customerGroupId'] as String?,
    );

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': const NonNullableTimestampConverter().toJson(instance.date),
      'customerGroupId': instance.customerGroupId,
    };

_CustomerGroup _$CustomerGroupFromJson(Map<String, dynamic> json) =>
    _CustomerGroup(
      id: json['id'] as String,
      tourTypeId: json['tourTypeId'] as String?,
      maxCapacity: (json['maxCapacity'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? "",
      datetime: const NonNullableTimestampConverter()
          .fromJson(json['datetime'] as Timestamp),
      teamGroupId: json['teamGroupId'] as String?,
    );

Map<String, dynamic> _$CustomerGroupToJson(_CustomerGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tourTypeId': instance.tourTypeId,
      'maxCapacity': instance.maxCapacity,
      'name': instance.name,
      'datetime':
          const NonNullableTimestampConverter().toJson(instance.datetime),
      'teamGroupId': instance.teamGroupId,
    };
