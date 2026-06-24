import 'package:mush_on/customer_management/models.dart';

enum BookingAction { refund, cancel, none }

/// Decides which destructive action the editor should offer.
/// - paid (on-platform)            -> refund (Stripe, claws back commission)
/// - deferredPayment / waiting /
///   unknown / paidOffPlatform      -> cancel (no Stripe; just free the seat)
/// - refunded                       -> none (already terminal)
BookingAction bookingActionFor(Booking booking) {
  switch (booking.paymentStatus) {
    case PaymentStatus.paid:
      return BookingAction.refund;
    case PaymentStatus.refunded:
      return BookingAction.none;
    case PaymentStatus.deferredPayment:
    case PaymentStatus.waiting:
    case PaymentStatus.unknown:
    case PaymentStatus.paidOffPlatform:
      return BookingAction.cancel;
  }
}
