// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reseller _$ResellerFromJson(Map<String, dynamic> json) => _Reseller(
      phoneNumber: json['phoneNumber'] as String,
      businessInfo: ResellerBusinessInfo.fromJson(
          json['businessInfo'] as Map<String, dynamic>),
      createdAt: const NonNullableTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
      updatedAt: const NonNullableTimestampConverter()
          .fromJson(json['updatedAt'] as Timestamp),
      assignedAccountIds: (json['assignedAccountIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      status: $enumDecode(_$ResellerStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ResellerToJson(_Reseller instance) => <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'businessInfo': instance.businessInfo.toJson(),
      'createdAt':
          const NonNullableTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const NonNullableTimestampConverter().toJson(instance.updatedAt),
      'assignedAccountIds': instance.assignedAccountIds,
      'discount': instance.discount,
      'status': _$ResellerStatusEnumMap[instance.status]!,
    };

const _$ResellerStatusEnumMap = {
  ResellerStatus.active: 'active',
  ResellerStatus.inactive: 'inactive',
};

_ResellerBusinessInfo _$ResellerBusinessInfoFromJson(
        Map<String, dynamic> json) =>
    _ResellerBusinessInfo(
      legalName: json['legalName'] as String,
      addressLineOne: json['addressLineOne'] as String,
      addressLineTwo: json['addressLineTwo'] as String?,
      province: json['province'] as String?,
      zipCode: json['zipCode'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      businessId: json['businessId'] as String,
    );

Map<String, dynamic> _$ResellerBusinessInfoToJson(
        _ResellerBusinessInfo instance) =>
    <String, dynamic>{
      'legalName': instance.legalName,
      'addressLineOne': instance.addressLineOne,
      'addressLineTwo': instance.addressLineTwo,
      'province': instance.province,
      'zipCode': instance.zipCode,
      'city': instance.city,
      'country': instance.country,
      'businessId': instance.businessId,
    };

_ResellerSettings _$ResellerSettingsFromJson(Map<String, dynamic> json) =>
    _ResellerSettings(
      allowedDelayedPayment: json['allowedDelayedPayment'] as bool? ?? false,
      paymentDelayDays: (json['paymentDelayDays'] as num?)?.toInt() ?? 28,
    );

Map<String, dynamic> _$ResellerSettingsToJson(_ResellerSettings instance) =>
    <String, dynamic>{
      'allowedDelayedPayment': instance.allowedDelayedPayment,
      'paymentDelayDays': instance.paymentDelayDays,
    };
