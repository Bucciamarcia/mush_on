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
      isSingleDriver: json['isSingleDriver'] as bool? ?? false,
      weight: (json['weight'] as num?)?.toInt(),
      isDriving: json['isDriving'] as bool? ?? true,
    );

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'name': instance.name,
      'email': instance.email,
      'age': instance.age,
      'isSingleDriver': instance.isSingleDriver,
      'weight': instance.weight,
      'isDriving': instance.isDriving,
    };

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
      id: json['id'] as String,
      customerGroupId: json['customerGroupId'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
      'id': instance.id,
      'customerGroupId': instance.customerGroupId,
      'price': instance.price,
    };

_CustomerGroup _$CustomerGroupFromJson(Map<String, dynamic> json) =>
    _CustomerGroup(
      id: json['id'] as String,
      teamGroupId: json['teamGroupId'] as String?,
    );

Map<String, dynamic> _$CustomerGroupToJson(_CustomerGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamGroupId': instance.teamGroupId,
    };
