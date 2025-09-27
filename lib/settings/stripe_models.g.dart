// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StripeConnection _$StripeConnectionFromJson(Map<String, dynamic> json) =>
    _StripeConnection(
      accountId: json['accountId'] as String,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$StripeConnectionToJson(_StripeConnection instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'isActive': instance.isActive,
    };
