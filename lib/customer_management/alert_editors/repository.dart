import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/services/error_handling.dart';

import '../models.dart';

class AlertEditorsRepository {
  final String account;
  final FirebaseFunctions functions;
  final logger = BasicLogger();
  AlertEditorsRepository({required this.account, FirebaseFunctions? functions})
    : functions =
          functions ?? FirebaseFunctions.instanceFor(region: "europe-north1");

  Future<void> refundBooking(Booking booking) async {
    try {
      await functions.httpsCallable("refund_payment").call({
        "account": account,
        "bookingId": booking.id,
      });
      logger.info("Payment refunded");
    } catch (e, s) {
      logger.error("Failed to refund booking", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Cancels a non-paid booking: deletes it (and its customers), freeing the
  /// seat. No Stripe involved.
  Future<void> cancelBooking(Booking booking) async {
    try {
      await functions.httpsCallable("cancel_booking").call({
        "account": account,
        "bookingId": booking.id,
      });
      logger.info("Booking cancelled");
    } catch (e, s) {
      logger.error("Failed to cancel booking", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Marks a booking as paid off-platform (cash / bank transfer). No Stripe,
  /// no commission.
  Future<void> markBookingPaidOffPlatform(Booking booking) async {
    try {
      await functions.httpsCallable("mark_booking_paid_off_platform").call({
        "account": account,
        "bookingId": booking.id,
      });
      logger.info("Booking marked paid off-platform");
    } catch (e, s) {
      logger.error(
        "Failed to mark booking paid off-platform",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// (Re)sends the deferred-payment email (with the pay link) to the partner.
  Future<void> sendDeferredPaymentEmail(Booking booking) async {
    try {
      await functions.httpsCallable("send_deferred_payment_email").call({
        "account": account,
        "bookingId": booking.id,
      });
      logger.info("Deferred payment email sent");
    } catch (e, s) {
      logger.error(
        "Failed to send deferred payment email",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}
