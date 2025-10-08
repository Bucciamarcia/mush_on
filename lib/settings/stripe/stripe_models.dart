import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/models/custom_converters.dart';
part 'stripe_models.freezed.dart';
part 'stripe_models.g.dart';

@freezed
sealed class StripeConnection with _$StripeConnection {
  const factory StripeConnection({
    required String accountId,
    @Default(false) bool isActive,
  }) = _StripeConnection;

  factory StripeConnection.fromJson(Map<String, dynamic> json) =>
      _$StripeConnectionFromJson(json);
}

@freezed

/// Represent a Stripe payment intent, used to associate it with account and booking.
/// When the webook for success payment intent arrives, search this db to
/// find which account and booking it refers to.
sealed class CheckoutSession with _$CheckoutSession {
  const factory CheckoutSession(
      {required String checkoutSessionId,

      /// The name of the account that this payment goes to.
      required String account,

      /// The ID of the booking
      required String bookingId,

      /// The Stripe ID of the account.
      required String stripeId,
      @NonNullableTimestampConverter() required DateTime createdAt,
      required bool webhookProcessed}) = _CheckoutSession;

  factory CheckoutSession.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionFromJson(json);
}
