// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StripeAccount _$StripeAccountFromJson(Map<String, dynamic> json) =>
    _StripeAccount(
      accountId: json['accountId'] as String,
      mode: $enumDecode(_$StripeModeEnumMap, json['mode']),
      archived: json['archived'] as bool? ?? false,
      connectedAt: const TimestampConverter().fromJson(
        json['connectedAt'] as Timestamp?,
      ),
      archivedAt: const TimestampConverter().fromJson(
        json['archivedAt'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$StripeAccountToJson(_StripeAccount instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'mode': _$StripeModeEnumMap[instance.mode]!,
      'archived': instance.archived,
      'connectedAt': const TimestampConverter().toJson(instance.connectedAt),
      'archivedAt': const TimestampConverter().toJson(instance.archivedAt),
    };

const _$StripeModeEnumMap = {StripeMode.live: 'live', StripeMode.test: 'test'};

_StripeConnection _$StripeConnectionFromJson(Map<String, dynamic> json) =>
    _StripeConnection(
      live: json['live'] == null
          ? null
          : StripeModeConnection.fromJson(json['live'] as Map<String, dynamic>),
      test: json['test'] == null
          ? null
          : StripeModeConnection.fromJson(json['test'] as Map<String, dynamic>),
      activeMode:
          $enumDecodeNullable(_$StripeModeEnumMap, json['activeMode']) ??
          StripeMode.test,
    );

Map<String, dynamic> _$StripeConnectionToJson(_StripeConnection instance) =>
    <String, dynamic>{
      'live': instance.live?.toJson(),
      'test': instance.test?.toJson(),
      'activeMode': _$StripeModeEnumMap[instance.activeMode]!,
    };

_StripeModeConnection _$StripeModeConnectionFromJson(
  Map<String, dynamic> json,
) => _StripeModeConnection(
  accountId: json['accountId'] as String,
  isActive: json['isActive'] as bool? ?? false,
  connectedAt: const TimestampConverter().fromJson(
    json['connectedAt'] as Timestamp?,
  ),
);

Map<String, dynamic> _$StripeModeConnectionToJson(
  _StripeModeConnection instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'isActive': instance.isActive,
  'connectedAt': const TimestampConverter().toJson(instance.connectedAt),
};

_CheckoutSession _$CheckoutSessionFromJson(Map<String, dynamic> json) =>
    _CheckoutSession(
      checkoutSessionId: json['checkoutSessionId'] as String,
      stripeMode:
          $enumDecodeNullable(_$StripeModeEnumMap, json['stripeMode']) ??
          StripeMode.test,
      account: json['account'] as String,
      bookingId: json['bookingId'] as String,
      stripeId: json['stripeId'] as String,
      createdAt: const NonNullableTimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      webhookProcessed: json['webhookProcessed'] as bool,
    );

Map<String, dynamic> _$CheckoutSessionToJson(
  _CheckoutSession instance,
) => <String, dynamic>{
  'checkoutSessionId': instance.checkoutSessionId,
  'stripeMode': _$StripeModeEnumMap[instance.stripeMode]!,
  'account': instance.account,
  'bookingId': instance.bookingId,
  'stripeId': instance.stripeId,
  'createdAt': const NonNullableTimestampConverter().toJson(instance.createdAt),
  'webhookProcessed': instance.webhookProcessed,
};

_StripeConnectionStatus _$StripeConnectionStatusFromJson(
  Map<String, dynamic> json,
) => _StripeConnectionStatus(
  activeMode: $enumDecode(_$StripeModeEnumMap, json['activeMode']),
  hasAccount: json['hasAccount'] as bool,
  isReady: json['isReady'] as bool,
  chargesEnabled: json['chargesEnabled'] as bool,
  payoutsEnabled: json['payoutsEnabled'] as bool,
  detailsSubmitted: json['detailsSubmitted'] as bool,
  disabledReason: json['disabledReason'] as String?,
  reason: json['reason'] as String,
);

Map<String, dynamic> _$StripeConnectionStatusToJson(
  _StripeConnectionStatus instance,
) => <String, dynamic>{
  'activeMode': _$StripeModeEnumMap[instance.activeMode]!,
  'hasAccount': instance.hasAccount,
  'isReady': instance.isReady,
  'chargesEnabled': instance.chargesEnabled,
  'payoutsEnabled': instance.payoutsEnabled,
  'detailsSubmitted': instance.detailsSubmitted,
  'disabledReason': instance.disabledReason,
  'reason': instance.reason,
};

_BookingManagerKennelInfo _$BookingManagerKennelInfoFromJson(
  Map<String, dynamic> json,
) => _BookingManagerKennelInfo(
  name: json['name'] as String,
  url: json['url'] as String,
  email: json['email'] as String,
  cancellationPolicy: json['cancellationPolicy'] as String,
  customerCustomFields:
      (json['customerCustomFields'] as List<dynamic>?)
          ?.map((e) => CustomerCustomField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  bookingCustomFields:
      (json['bookingCustomFields'] as List<dynamic>?)
          ?.map((e) => BookingCustomField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  bookingReminders:
      (json['bookingReminders'] as List<dynamic>?)
          ?.map((e) => BookingReminder.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  timezone: json['timezone'] as String? ?? "Europe/Helsinki",
  vatRate: (json['vatRate'] as num).toDouble(),
  commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 0.035,
  invoicingEnabled: json['invoicingEnabled'] as bool? ?? false,
  invoiceLegalName: json['invoiceLegalName'] as String? ?? "",
  invoiceAddress: json['invoiceAddress'] as String? ?? "",
  invoiceBusinessId: json['invoiceBusinessId'] as String? ?? "",
  invoiceNumberPrefix: json['invoiceNumberPrefix'] as String? ?? "",
  nextInvoiceNumber: (json['nextInvoiceNumber'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$BookingManagerKennelInfoToJson(
  _BookingManagerKennelInfo instance,
) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
  'email': instance.email,
  'cancellationPolicy': instance.cancellationPolicy,
  'customerCustomFields': instance.customerCustomFields
      .map((e) => e.toJson())
      .toList(),
  'bookingCustomFields': instance.bookingCustomFields
      .map((e) => e.toJson())
      .toList(),
  'bookingReminders': instance.bookingReminders.map((e) => e.toJson()).toList(),
  'timezone': instance.timezone,
  'vatRate': instance.vatRate,
  'commissionRate': instance.commissionRate,
  'invoicingEnabled': instance.invoicingEnabled,
  'invoiceLegalName': instance.invoiceLegalName,
  'invoiceAddress': instance.invoiceAddress,
  'invoiceBusinessId': instance.invoiceBusinessId,
  'invoiceNumberPrefix': instance.invoiceNumberPrefix,
  'nextInvoiceNumber': instance.nextInvoiceNumber,
};

_BookingReminder _$BookingReminderFromJson(Map<String, dynamic> json) =>
    _BookingReminder(
      uid: json['uid'] as String,
      daysBefore: (json['daysBefore'] as num).toInt(),
    );

Map<String, dynamic> _$BookingReminderToJson(_BookingReminder instance) =>
    <String, dynamic>{'uid': instance.uid, 'daysBefore': instance.daysBefore};
