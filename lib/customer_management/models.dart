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

    /// The date and time of the booking
    @NonNullableTimestampConverter() required DateTime date,

    /// The ID of the CustomerGroup this booking is part of.
    ///
    /// Nullable because bookings when they're created they may not be assigned yet.
    String? customerGroupId,
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

    /// The ID of the tour type this customergroup is assigned to.
    String? tourTypeId,

    /// The internal user friendly name of the customer group
    @Default("") String name,
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
