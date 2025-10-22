import 'package:freezed_annotation/freezed_annotation.dart';
part 'models.freezed.dart';
part 'models.g.dart';

@freezed

/// A single reseller. The reseller is an ENTITY, multiple users can be added to a reseller (not available yet)
sealed class Reseller with _$Reseller {
  const factory Reseller({
    /// Contact email for all the business stuff
    required String email,
    required ResellerBusinessInfo businessInfo,

    /// The list of accounts this entity is a reseller of.
    /// Useful for operators that work with multiple kennels.
    @Default(<String>[]) List<String> accountsAssigned,

    /// Discout to apply to this business off of the regular price.
    ///
    /// Must be a fraction, eg: 0.15 = 15% discount.
    @Default(0) double discount,
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
