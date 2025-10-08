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

_CheckoutSession _$CheckoutSessionFromJson(Map<String, dynamic> json) =>
    _CheckoutSession(
      checkoutSessionId: json['checkoutSessionId'] as String,
      account: json['account'] as String,
      bookingId: json['bookingId'] as String,
      stripeId: json['stripeId'] as String,
      createdAt: const NonNullableTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
      webhookProcessed: json['webhookProcessed'] as bool,
    );

Map<String, dynamic> _$CheckoutSessionToJson(_CheckoutSession instance) =>
    <String, dynamic>{
      'checkoutSessionId': instance.checkoutSessionId,
      'account': instance.account,
      'bookingId': instance.bookingId,
      'stripeId': instance.stripeId,
      'createdAt':
          const NonNullableTimestampConverter().toJson(instance.createdAt),
      'webhookProcessed': instance.webhookProcessed,
    };
