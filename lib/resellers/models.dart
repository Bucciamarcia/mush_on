import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/models/custom_converters.dart';
part 'models.freezed.dart';
part 'models.g.dart';

@freezed

/// A single reseller with its own login.
sealed class Reseller with _$Reseller {
  @JsonSerializable(explicitToJson: true)
  const factory Reseller({
    /// The phone number to contact
    required String phoneNumber,
    required ResellerBusinessInfo businessInfo,
    @NonNullableTimestampConverter() required DateTime createdAt,
    @NonNullableTimestampConverter() required DateTime updatedAt,

    /// The list of accounts this entity is a reseller of.
    /// Useful for operators that work with multiple kennels.
    @Default(<String>[]) List<String> assignedAccountIds,

    /// Discout to apply to this business off of the regular price.
    ///
    /// Must be a fraction, eg: 0.15 = 15% discount.
    @Default(0) double discount,

    /// The current status of this reseller
    required ResellerStatus status,
  }) = _Reseller;
  factory Reseller.fromJson(Map<String, dynamic> json) =>
      _$ResellerFromJson(json);
}

@freezed

/// The legal business information for the entity.
sealed class ResellerBusinessInfo with _$ResellerBusinessInfo {
  const factory ResellerBusinessInfo({
    /// Legal name of the address
    required String legalName,

    /// Line 1 of the business address
    required String addressLineOne,

    /// Second (optional) line of the address
    String? addressLineTwo,
    String? province,
    required String zipCode,
    required String city,
    required String country,

    /// Business id or VAT number of the business to put on invoice.
    required String businessId,
  }) = _ResellerBusinessInfo;

  factory ResellerBusinessInfo.fromJson(Map<String, dynamic> json) =>
      _$ResellerBusinessInfoFromJson(json);
}

@freezed

/// Settigns related to the reseller portal
sealed class ResellerSettings with _$ResellerSettings {
  const factory ResellerSettings({
    /// Whether to allow the reseller to pay after making the booking
    @Default(false) bool allowedDelayedPayment,

    /// How many days before the booking the payment must be completed
    ///
    /// If `allowDelayedPayment` is false, this is ignored.
    @Default(28) int paymentDelayDays,
  }) = _ResellerSettings;

  factory ResellerSettings.fromJson(Map<String, dynamic> json) =>
      _$ResellerSettingsFromJson(json);
}

@JsonEnum()
enum ResellerStatus {
  active,
  inactive;
}
