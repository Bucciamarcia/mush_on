import 'package:mush_on/customer_management/models.dart';

enum BookingAction { refund, cancel, none }

class BulkRefundResult {
  final int attemptedCount;
  final int refundedCount;
  final Booking? failedBooking;
  final Object? error;

  const BulkRefundResult({
    required this.attemptedCount,
    required this.refundedCount,
    this.failedBooking,
    this.error,
  });

  bool get completed => failedBooking == null;
}

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

Future<BulkRefundResult> refundPaidBookingsOneByOne(
  List<Booking> bookings,
  Future<void> Function(Booking booking) refundBooking,
) async {
  final paidBookings = bookings
      .where((booking) => booking.paymentStatus.isOnPlatformPaid)
      .toList();
  var refundedCount = 0;
  for (final booking in paidBookings) {
    try {
      await refundBooking(booking);
      refundedCount++;
    } catch (e) {
      return BulkRefundResult(
        attemptedCount: paidBookings.length,
        refundedCount: refundedCount,
        failedBooking: booking,
        error: e,
      );
    }
  }
  return BulkRefundResult(
    attemptedCount: paidBookings.length,
    refundedCount: refundedCount,
  );
}
