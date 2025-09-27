import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe_models.dart';
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

  Future<void> bookTourFirebase(
      Booking booking, List<Customer> customers) async {
    final ref = FirebaseFunctions.instanceFor(region: "europe-north1");
    final bookingData = booking.copyWith(name: "Test name");
    List<Map<String, dynamic>> customersData = [];
    for (final customer in customers) {
      final cData = customer.copyWith(bookingId: booking.id);
      customersData.add(cData.toJson());
    }
    try {
      logger.debug("Calling book tour firebase");
      await ref.httpsCallable("add_booking").call({
        "booking": bookingData.toJson(),
        "customers": customersData,
        "account": account
      });
    } catch (e, s) {
      logger.error("Failed to book tour", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<StripeConnection> getStripeConnection() async {
    try {
      final response =
          await FirebaseFunctions.instanceFor(region: "europe-north1")
              .httpsCallable("get_stripe_integration_data")
              .call({"account": account});
      final data = response.data as Map<String, dynamic>;
      return StripeConnection.fromJson(data);
    } catch (e, s) {
      logger.error("Failed to get stripe connection", error: e, stackTrace: s);
      rethrow;
    }
  }
}
