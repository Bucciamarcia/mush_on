import 'package:freezed_annotation/freezed_annotation.dart';
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

    /// If the customer is going on a single sled. If false, double sled usually.
    @Default(false) bool isSingleDriver,

    /// The weight of the individual. Useful for distributing weight or assigning strong dogs.
    int? weight,

    /// Does this customer want to drive the sled? Must be false for minors.
    @Default(true) bool isDriving,
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

    /// The ID of the CustomerGroup this booking is part of.
    ///
    /// Nullable because bookings when they're created they may not be assigned yet.
    String? customerGroupId,

    /// How much this group has paid
    @Default(0) double price,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
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
