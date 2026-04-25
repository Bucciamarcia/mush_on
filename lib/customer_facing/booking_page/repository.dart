import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import '../../customer_management/models.dart';

class BookingPageRepository {
  final String account;
  final String tourId;
  final logger = BasicLogger();

  BookingPageRepository({required this.account, required this.tourId});

  Future<String> getStripePaymentUrl({
    required Booking booking,
    required List<Customer> customers,
  }) async {
    try {
      await bookTour(booking, customers);
    } catch (e, s) {
      logger.error(
        "Failed to book tour before getting payment url",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
    try {
      logger.debug("Account: $account");
      final response =
          await FirebaseFunctions.instanceFor(
            region: "europe-north1",
          ).httpsCallable("create_checkout_session").call({
            "account": account,
            "bookingId": booking.id,
            "tourId": tourId,
            "customerGroupId": booking.customerGroupId,
          });
      final data = response.data as Map<String, dynamic>;
      final error = data["error"];
      if (error != null) {
        throw Exception("Error not null: ${error.toString()}");
      } else {
        logger.debug("Created checkout session successfully");
      }
      logger.debug("DATA: $data");
      final String url = data["url"];
      return url;
    } catch (e, s) {
      logger.error(
        "Failed to create checkout session",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Initial add to the db of the tour.
  Future<void> bookTour(Booking booking, List<Customer> customers) async {
    final ref = FirebaseFunctions.instanceFor(region: "europe-north1");
    final bookingLabel = _getBookingLabel(booking, customers);
    final bookingData = booking.copyWith(
      name: bookingLabel,
      paymentStatus: PaymentStatus.waiting,
    );
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
        "account": account,
      });
    } catch (e, s) {
      logger.error("Failed to book tour", error: e, stackTrace: s);
      rethrow;
    }
  }

  String _getBookingLabel(Booking booking, List<Customer> customers) {
    if (booking.name.trim().isNotEmpty) return booking.name.trim();
    for (final customer in customers) {
      if (customer.name.trim().isNotEmpty) return customer.name.trim();
      for (final value in customer.customerOtherInfo.values) {
        if (value.trim().isNotEmpty) return value.trim();
      }
    }
    return "Booking";
  }

  Future<StripeConnection> getStripeConnection() async {
    try {
      final response = await FirebaseFunctions.instanceFor(
        region: "europe-north1",
      ).httpsCallable("get_stripe_integration_data").call({"account": account});
      final data = response.data as Map<String, dynamic>;
      return StripeConnection.fromJson(data);
    } catch (e, s) {
      logger.error("Failed to get stripe connection", error: e, stackTrace: s);
      rethrow;
    }
  }

  static Future<String> getFullPrivacyPolicy() async {
    const path = "global/privacyPolicy";
    final db = FirebaseFirestore.instance;
    try {
      final snapshot = await db.doc(path).get();
      final data = snapshot.data();
      if (data == null) throw Exception("No privacy policy found");
      return data["fullHtml"];
    } catch (e) {
      return "";
    }
  }
}
