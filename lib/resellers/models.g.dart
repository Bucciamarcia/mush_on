// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reseller _$ResellerFromJson(Map<String, dynamic> json) => _Reseller(
      email: json['email'] as String,
      businessInfo: ResellerBusinessInfo.fromJson(
          json['businessInfo'] as Map<String, dynamic>),
      accountsAssigned: (json['accountsAssigned'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ResellerToJson(_Reseller instance) => <String, dynamic>{
      'email': instance.email,
      'businessInfo': instance.businessInfo.toJson(),
      'accountsAssigned': instance.accountsAssigned,
      'discount': instance.discount,
    };

_ResellerBusinessInfo _$ResellerBusinessInfoFromJson(
        Map<String, dynamic> json) =>
    _ResellerBusinessInfo(
      legalName: json['legalName'] as String,
      addressLineOne: json['addressLineOne'] as String,
      addressLineTwo: json['addressLineTwo'] as String?,
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
