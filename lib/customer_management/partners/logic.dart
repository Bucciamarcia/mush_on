import 'package:mush_on/customer_management/partners/models.dart';

/// Whether the partner may choose deferred payment at checkout.
bool canDeferPayment(Partner? partner) =>
    partner != null && partner.allowDeferred;

/// Apply a partner discount to a price. Rounds to the nearest cent.
/// Returns the original price when there is no partner / no discount.
int discountedPriceCents(int priceCents, Partner? partner) {
  final rate = partner?.discountRate;
  if (rate == null || rate <= 0) return priceCents;
  return (priceCents * (1 - rate)).round();
}

/// Removes inclusive VAT from a gross price. Returns the original price when
/// the VAT rate is zero or invalid.
int vatExclusivePriceCents(int grossPriceCents, double vatRate) {
  if (vatRate <= 0) return grossPriceCents;
  return (grossPriceCents / (1 + vatRate)).round();
}

/// Applies partner tax and discount rules in the same order as checkout:
/// reverse-charge VAT first, then partner discount.
int partnerCheckoutPriceCents({
  required int grossPriceCents,
  required double vatRate,
  required Partner? partner,
}) {
  final taxablePrice = partner?.reverseChargeVat == true
      ? vatExclusivePriceCents(grossPriceCents, vatRate)
      : grossPriceCents;
  return discountedPriceCents(taxablePrice, partner);
}

/// The date the deferred balance is due: the tour date minus the partner's
/// `deferredDays`. (NOTE: it is measured from the tour date, NOT from now.)
DateTime paymentDueDate(DateTime tourDate, Partner partner) =>
    tourDate.subtract(Duration(days: partner.deferredDays));
