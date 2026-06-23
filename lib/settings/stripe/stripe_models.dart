import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/models/custom_converters.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
part 'stripe_models.freezed.dart';
part 'stripe_models.g.dart';

@freezed
sealed class StripeAccount with _$StripeAccount {
  const factory StripeAccount({
    required String accountId,
    required StripeMode mode,
    @Default(false) bool archived,
    @TimestampConverter() DateTime? connectedAt,
    @TimestampConverter() DateTime? archivedAt,
  }) = _StripeAccount;

  factory StripeAccount.fromJson(Map<String, dynamic> json) =>
      _$StripeAccountFromJson(json);
}

@freezed
sealed class StripeConnection with _$StripeConnection {
  @JsonSerializable(explicitToJson: true)
  const factory StripeConnection({
    StripeModeConnection? live,
    StripeModeConnection? test,

    /// The currently selected payment mode.
    @Default(StripeMode.test) StripeMode activeMode,
  }) = _StripeConnection;

  factory StripeConnection.fromJson(Map<String, dynamic> json) =>
      _$StripeConnectionFromJson(json);
}

@freezed
sealed class StripeModeConnection with _$StripeModeConnection {
  const factory StripeModeConnection({
    required String accountId,
    @Default(false) bool isActive,
    @TimestampConverter() DateTime? connectedAt,
  }) = _StripeModeConnection;

  factory StripeModeConnection.fromJson(Map<String, dynamic> json) =>
      _$StripeModeConnectionFromJson(json);
}

@freezed
/// Represent a Stripe payment intent, used to associate it with account and booking.
/// When the webook for success payment intent arrives, search this db to
/// find which account and booking it refers to.
sealed class CheckoutSession with _$CheckoutSession {
  @JsonSerializable(explicitToJson: true)
  const factory CheckoutSession({
    required String checkoutSessionId,
    @Default(StripeMode.test) StripeMode stripeMode,

    /// The name of the account that this payment goes to.
    required String account,

    /// The ID of the booking
    required String bookingId,

    /// The Stripe ID of the account.
    required String stripeId,
    @NonNullableTimestampConverter() required DateTime createdAt,
    required bool webhookProcessed,
  }) = _CheckoutSession;

  factory CheckoutSession.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionFromJson(json);
}

@JsonEnum()
enum StripeMode { live, test }

@freezed
sealed class StripeConnectionStatus with _$StripeConnectionStatus {
  @JsonSerializable(explicitToJson: true)
  const factory StripeConnectionStatus({
    required StripeMode activeMode,
    required bool hasAccount,
    required bool isReady,
    required bool chargesEnabled,
    required bool payoutsEnabled,
    required bool detailsSubmitted,
    required String? disabledReason,
    required String reason,
  }) = _StripeConnectionStatus;

  factory StripeConnectionStatus.fromJson(Map<String, dynamic> json) =>
      _$StripeConnectionStatusFromJson(json);
}

@freezed
/// Information about the kennel manager booking settings.
sealed class BookingManagerKennelInfo with _$BookingManagerKennelInfo {
  @JsonSerializable(explicitToJson: true)
  const factory BookingManagerKennelInfo({
    required String name,
    required String url,
    required String email,
    required String cancellationPolicy,
    @Default([]) List<CustomerCustomField> customerCustomFields,
    @Default([]) List<BookingCustomField> bookingCustomFields,

    /// The reminders the customer will receive before the trip.
    @Default([]) List<BookingReminder> bookingReminders,

    /// IANA timezone identifier for this kennel's location, used to display
    /// booking times correctly in emails (e.g. "Europe/Helsinki").
    @Default("Europe/Helsinki") String timezone,

    /// The vat rate to apply to the platform commission. 0 (reverse charged) unless in Finland, then 0.255.
    required double vatRate,

    /// The commission rate of the platform on payments. Defaults to 3.5%.
    @Default(0.035) double commissionRate,
  }) = _BookingManagerKennelInfo;

  factory BookingManagerKennelInfo.fromJson(Map<String, dynamic> json) =>
      _$BookingManagerKennelInfoFromJson(json);
}

@freezed
sealed class BookingReminder with _$BookingReminder {
  const factory BookingReminder({
    /// UID of the reminder.
    required String uid,

    /// How many days before to send the reminder.
    /// 0 is the day of the trip, 1 is 1 day before etc.
    required int daysBefore,
  }) = _BookingReminder;

  factory BookingReminder.fromJson(Map<String, dynamic> json) =>
      _$BookingReminderFromJson(json);
}
