import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models/dog.dart';
part 'models.freezed.dart';
part 'models.g.dart';

@freezed

/// The type of the tour for the customer.
///
/// For example, 10km, 20km with lunch, 2km no drive, etc.
/// Every customer group has a TourType assigned to it.
sealed class TourType with _$TourType {
  const factory TourType({
    required String id,

    /// Internal name of the tour type.
    @Default("") String name,

    /// Name of  the tour to show to the customers.
    @Default("") String displayName,

    /// How many km this tour will do.
    @Default(0) double distance,

    /// Duration of the tour in minutes.
    required int duration,

    /// Internal notes regarding the tour.
    String? notes,

    /// Description to show to the customer of this tour.
    String? displayDescription,

    /// Internal color for easy visual identification of the tour.
    @ColorConverter() required Color backgroundColor,

    /// Archives the tour (can't delete for stats).
    @Default(false) bool isArchived,
  }) = _TourType;

  factory TourType.fromJson(Map<String, dynamic> json) =>
      _$TourTypeFromJson(json);
}

@freezed

/// The pricing options to be assigned to the TourType.
/// eg. "adult", "child", "single driver".
///
/// In the DB this is a subcollection of TourType.
sealed class TourTypePricing with _$TourTypePricing {
  const factory TourTypePricing(
      {required String id,

      /// The internal name of this pricing.
      @Default("") String name,

      /// Is the price archived? Can't be deleted or edited bc continuity.
      @Default(false) bool isArchived,

      /// The display name of this pricing, to show to customers.
      @Default("") String displayName,

      /// The internal notes of this pricing.
      String? notes,

      /// The description of this tour to show to customers.
      String? displayDescription,

      /// The price of this tour. This is VAT included.
      @Default(0) int priceCents,

      /// The vat rate of this price.
      @Default(0) double vatRate,

      /// The id for the stripe tax rate
      String? stripeTaxRateId}) = _TourTypePricing;

  factory TourTypePricing.fromJson(Map<String, dynamic> json) =>
      _$TourTypePricingFromJson(json);
}

extension TourTypePricingExtension on List<TourTypePricing> {
  TourTypePricing pricingFromId(String id) {
    return firstWhere((pricing) => pricing.id == id);
  }
}
