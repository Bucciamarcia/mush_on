import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/models/custom_converters.dart';
part 'models.g.dart';
part 'models.freezed.dart';

@freezed
/// A single customer, who is a person.
/// Can be part of a larger group or come alone.
sealed class Customer with _$Customer {
  const factory Customer({
    required String id,

    /// The booking Id this customer is part of.
    ///
    /// Must always exist, because customers need a booking to book a tour!
    required String bookingId,

    /// The full name of the customer.
    @Default("") String name,

    /// The email address of the customer.
    String? email,

    /// The age of the customer (to check if child).
    int? age,

    /// The weight of the individual. Useful for distributing weight or assigning strong dogs.
    int? weight,

    /// The team Id this customer will go on.
    String? teamId,

    /// The ID of the pricing for this customer.
    String? pricingId,
    @Default(<String, String>{}) Map<String, String> customerOtherInfo,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
/// Represent a single booking, made of multipe people.
/// These people pay together and stay together. Like a single family.
sealed class Booking with _$Booking {
  @JsonSerializable(explicitToJson: true)
  const factory Booking({
    required String id,

    /// The internal user friendly name of this group.
    @Default("") String name,

    /// The ID of the CustomerGroup this booking is part of.
    ///
    /// Required because CustomerGroup is where date time is.
    required String customerGroupId,

    /// The phone left for this booking.
    String? phone,

    /// The reference email for this booking.
    String? email,

    /// The street address of the customer.
    String? streetAddress,
    String? zipCode,
    String? city,
    String? country,
    @Default(PaymentStatus.unknown) PaymentStatus paymentStatus,

    /// The id of the partner (reseller) this booking belongs to, if any.
    String? partner,

    /// Whether VAT was reverse charged for this booking at creation time.
    @Default(false) bool reverseChargeVat,

    /// The total price of the booking in cents, AFTER any partner discount.
    /// Stored at creation for deferred / off-platform bookings so the financial
    /// dashboard and the payment email have an amount without re-hitting Stripe.
    /// For on-platform paid bookings the authoritative value is on the
    /// CheckoutSession, but we mirror it here for convenience.
    int? totalCents,

    /// When this booking was created.
    ///
    /// Nullable for compatibility with bookings created before this field
    /// existed.
    @TimestampConverter() DateTime? createdOn,
    @TimestampConverter() DateTime? expiresAt,
    @Default(<String, String>{}) Map<String, String> otherBookingData,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

extension BookingsExtension on List<Booking> {
  /// Only returns bookings that either have been already paid or are deferred,
  /// or paid off-platform — all of which occupy a seat in the customer group.
  List<Booking> get active =>
      where((b) => b.paymentStatus.occupiesSeat).toList();
}

extension PaymentStatusX on PaymentStatus {
  /// True when the booking holds a seat in its customer group.
  bool get occupiesSeat =>
      this == PaymentStatus.paid ||
      this == PaymentStatus.deferredPayment ||
      this == PaymentStatus.paidOffPlatform;

  /// True when money actually moved through Stripe (so it can be refunded
  /// and earned us a commission).
  bool get isOnPlatformPaid => this == PaymentStatus.paid;
}

enum BookingPaymentDisplayStatus {
  paid,
  deferredPayment,
  waiting,
  paymentCancelled,
  refunded,
  paidOffPlatform,
  unknown,
}

extension BookingPaymentStatusX on Booking {
  bool isWaitingPaymentExpired(DateTime now) {
    return paymentStatus == PaymentStatus.waiting &&
        expiresAt != null &&
        !expiresAt!.isAfter(now);
  }

  /// This status is computed in the frontend for display only; it is not a
  /// separate value stored in the database.
  BookingPaymentDisplayStatus displayPaymentStatus(DateTime now) {
    if (isWaitingPaymentExpired(now)) {
      return BookingPaymentDisplayStatus.paymentCancelled;
    }
    return switch (paymentStatus) {
      PaymentStatus.paid => BookingPaymentDisplayStatus.paid,
      PaymentStatus.deferredPayment =>
        BookingPaymentDisplayStatus.deferredPayment,
      PaymentStatus.waiting => BookingPaymentDisplayStatus.waiting,
      PaymentStatus.refunded => BookingPaymentDisplayStatus.refunded,
      PaymentStatus.paidOffPlatform =>
        BookingPaymentDisplayStatus.paidOffPlatform,
      PaymentStatus.unknown => BookingPaymentDisplayStatus.unknown,
    };
  }

  bool blocksCustomerGroupDeletion(DateTime now) {
    return switch (paymentStatus) {
      PaymentStatus.paid ||
      PaymentStatus.paidOffPlatform ||
      PaymentStatus.deferredPayment => true,
      PaymentStatus.waiting => expiresAt == null || expiresAt!.isAfter(now),
      PaymentStatus.refunded || PaymentStatus.unknown => false,
    };
  }
}

@JsonEnum()
enum PaymentStatus {
  /// Tour fully paid
  @JsonValue("paid")
  paid,

  /// Payment at a later date, usually for invoiced payments
  @JsonValue("deferredPayment")
  deferredPayment,

  /// Waiting for the customer to pay. Usually takes minutes.
  @JsonValue("waiting")
  waiting,

  /// The payment has been refunded
  @JsonValue("refunded")
  refunded,

  /// Marked paid off-platform (cash / bank transfer). Occupies a seat and is
  /// active, but earns zero commission (no money moved through Stripe).
  @JsonValue("paidOffPlatform")
  paidOffPlatform,

  /// Payment status not known. Means there's been an error.
  @JsonValue("unknown")
  unknown,
}

@freezed
/// The entire group that will start together, and is considered a single unit.
/// Will be assigned to a TeamGroup 1=1 ot make sure all customers have a sled.
///
/// A CustomerGroup can have multiple bookings for mixed groups.
sealed class CustomerGroup with _$CustomerGroup {
  @JsonSerializable(explicitToJson: true)
  const factory CustomerGroup({
    required String id,

    /// The ID of the tour type this customergroup is assigned to.
    String? tourTypeId,

    /// The maximum capacity to limit the number of people.
    @Default(0) int maxCapacity,

    /// The internal user friendly name of the customer group
    @Default("") String name,

    /// Start date and time
    @NonNullableTimestampConverter() required DateTime datetime,

    /// The ID of the teamGroup this customerGroup is assigned to.
    /// Null if it has not been assigned to a teamgroup yet.
    ///
    /// Logic: customer groups are assigned 1=1 to teamGroups, they're very similar:
    /// The teamGroup handles the dogs, the customerGroup handles the humans.
    String? teamGroupId,
  }) = _CustomerGroup;

  factory CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);
}
