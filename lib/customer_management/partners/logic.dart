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

/// The date the deferred balance is due: the tour date minus the partner's
/// `deferredDays`. (NOTE: it is measured from the tour date, NOT from now.)
DateTime paymentDueDate(DateTime tourDate, Partner partner) =>
    tourDate.subtract(Duration(days: partner.deferredDays));
