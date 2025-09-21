import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';

import '../../customer_management/models.dart';

class BookingPageRepository {
  final String account;
  final String tourId;
  final logger = BasicLogger();

  BookingPageRepository({required this.account, required this.tourId});

  Future<void> bookTour(Booking booking, List<Customer> customers) async {
    final path = "accounts/$account/data/bookingManager";
    final db = FirebaseFirestore.instance;
    final batch = db.batch();

    // Deal with booking
    final doc = db.doc("$path/bookings/${booking.id}");
    final bookingData = booking.copyWith(name: "Test name");
    batch.set(doc, bookingData.toJson());

    // Deal with customers
    for (final customer in customers) {
      final doc = db.doc("$path/customers/${customer.id}");
      final customerData = customer.copyWith(bookingId: booking.id);
      batch.set(doc, customerData.toJson());
    }

    try {
      await batch.commit();
    } catch (e, s) {
      logger.error("Failed to book tour", error: e, stackTrace: s);
      rethrow;
    }
  }
}
