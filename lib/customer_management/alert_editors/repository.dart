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
}
