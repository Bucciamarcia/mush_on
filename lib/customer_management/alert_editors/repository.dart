import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/services/error_handling.dart';

import '../models.dart';

class AlertEditorsRepository {
  final String account;
  final db = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  final logger = BasicLogger();
  AlertEditorsRepository({required this.account});

  Future<void> refundBooking(Booking booking) async {
    // Get the payment intent id.
    final collection = db.collection("checkoutSessions");
    final ref = collection.where("bookingId", isEqualTo: booking.id);
    final snapshot = await ref.get();
    final docs = snapshot.docs;
    late final QueryDocumentSnapshot<Map<String, dynamic>> doc;
    try {
      doc = docs.single;
    } catch (e, s) {
      logger.error("Failed to find checkout session for booking ${booking.id}",
          error: e, stackTrace: s);
      rethrow;
    }
    final String paymentIntentId = doc.data()["paymentIntentId"];
    final String stripeAccount = doc.data()["stripeId"];

    // Refund the payment
    try {
      await functions.httpsCallable("refund_payment").call(
          {"paymentIntent": paymentIntentId, "stripeAccount": stripeAccount});
    } catch (e, s) {
      logger.error("Failed to refund booking because of the function",
          error: e, stackTrace: s);
      rethrow;
    }

    // Mark the booking as refunded in the db
    try {
      final path =
          "accounts/$account/data/bookingManager/bookings/${booking.id}";
      final newBooking =
          booking.copyWith(paymentStatus: PaymentStatus.refunded);
      await db.doc(path).set(newBooking.toJson());
      logger.info("Payment refunded");
    } catch (e, s) {
      logger.error("Failed to mark booking as refunded in the db",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
