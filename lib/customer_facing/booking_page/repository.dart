import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/customer_management/partners/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import '../../customer_management/models.dart';

class BookingPageRepository {
  final String account;
  final String tourId;
  final FirebaseFunctions functions;
  final logger = BasicLogger();

  BookingPageRepository({
    required this.account,
    required this.tourId,
    FirebaseFunctions? functions,
  }) : functions =
           functions ?? FirebaseFunctions.instanceFor(region: "europe-north1");

  Future<String> getStripePaymentUrl({
    required Booking booking,
    required List<Customer> customers,
    Partner? partner,
  }) async {
    try {
      logger.debug("Account: $account");
      final bookingLabel = _getBookingLabel(booking, customers);
      final bookingData = booking.copyWith(
        name: bookingLabel,
        paymentStatus: PaymentStatus.waiting,
      );
      final customersData = customers
          .map((customer) => customer.copyWith(bookingId: booking.id).toJson())
          .toList();
      // The discount itself is applied server-side — never trust the client
      // for the amount; we only forward the partner id.
      final payload = <String, dynamic>{
        "account": account,
        "tourId": tourId,
        "booking": bookingData.toJson(),
        "customers": customersData,
      };
      if (partner != null) {
        payload["partner"] = partner.id;
      }
      final response = await functions
          .httpsCallable("create_booking_checkout_session")
          .call(payload);
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

  /// Creates a confirmed-but-unpaid booking and triggers the partner email.
  /// Returns the bookingId. Calls "create_deferred_booking" with
  /// {account, tourId, booking, customers, partner: partner.id}.
  Future<String> createDeferredBooking({
    required Booking booking,
    required List<Customer> customers,
    required Partner partner,
  }) async {
    try {
      final bookingLabel = _getBookingLabel(booking, customers);
      final bookingData = booking.copyWith(
        name: bookingLabel,
        paymentStatus: PaymentStatus.deferredPayment,
      );
      final customersData = customers
          .map((customer) => customer.copyWith(bookingId: booking.id).toJson())
          .toList();
      final response = await functions
          .httpsCallable("create_deferred_booking")
          .call({
            "account": account,
            "tourId": tourId,
            "booking": bookingData.toJson(),
            "customers": customersData,
            "partner": partner.id,
          });
      final data = response.data as Map<String, dynamic>;
      final error = data["error"];
      if (error != null) {
        throw Exception("Error not null: ${error.toString()}");
      }
      final String bookingId = data["bookingId"];
      return bookingId;
    } catch (e, s) {
      logger.error(
        "Failed to create deferred booking",
        error: e,
        stackTrace: s,
      );
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
      final response = await functions
          .httpsCallable("get_public_stripe_status")
          .call({"account": account});
      final data = response.data as Map<String, dynamic>;
      final activeMode = data["activeMode"] == "live"
          ? StripeMode.live
          : StripeMode.test;
      final activeConnection = StripeModeConnection(
        accountId: "",
        isActive: data["isActive"] == true,
      );
      return StripeConnection(
        activeMode: activeMode,
        test: activeMode == StripeMode.test ? activeConnection : null,
        live: activeMode == StripeMode.live ? activeConnection : null,
      );
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
