import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:mush_on/customer_management/tours/models.dart';
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
    required List<TourTypePricing> pricings,
    required BookingManagerKennelInfo kennelInfo,
  }) async {
    try {
      await bookTour(booking, customers);
    } catch (e, s) {
      logger.error("Failed to book tour before getting payment url",
          error: e, stackTrace: s);
      rethrow;
    }
    Map<String, TourTypePricing> pricingsById = _getPricingsById(pricings);
    final List<Map<String, dynamic>> lineItems =
        _getLineItems(customers, pricingsById);
    final int totalCents = _getTotalCents(customers, pricingsById);
    final commissionRate = kennelInfo.commissionRate;
    final vatRate = 1 + kennelInfo.vatRate;
    final finalCommissionRate = commissionRate * vatRate;
    final int commissionCents = (totalCents * finalCommissionRate).toInt();
    try {
      logger.debug("Account: $account");
      final response =
          await FirebaseFunctions.instanceFor(region: "europe-north1")
              .httpsCallable("create_checkout_session")
              .call({
        "account": account,
        "lineItems": lineItems,
        "feeAmount": commissionCents,
        "bookingId": booking.id,
        "totalAmount": totalCents,
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
      logger.error("Failed to create checkout session",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Initial add to the db of the tour.
  Future<void> bookTour(Booking booking, List<Customer> customers) async {
    final ref = FirebaseFunctions.instanceFor(region: "europe-north1");
    final bookingData = booking.copyWith(
        name: customers.first.name, paymentStatus: PaymentStatus.waiting);
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

  int _getTotalCents(
      List<Customer> customers, Map<String, TourTypePricing> pricingsById) {
    int toReturn = 0;
    for (final customer in customers) {
      final pricing = pricingsById[customer.pricingId];
      toReturn += pricing?.priceCents ?? 0;
    }
    return toReturn;
  }

  List<Map<String, dynamic>> _getLineItems(
      List<Customer> customers, Map<String, TourTypePricing> pricingsById) {
    List<Map<String, dynamic>> lineItems = [];
    for (final customer in customers) {
      final pricing = pricingsById[customer.pricingId];
      if (pricing == null) {
        logger.error(
            "Couldn't find pricing for customer ${customer.name} with pricingId ${customer.pricingId}");
        throw Exception(
            "Couldn't find pricing for customer ${customer.name} with pricingId ${customer.pricingId}");
      }
      final lineItem = lineItems.firstWhereOrNull((i) =>
          i["price_data"]["product_data"]["metadata"]["pricing_id"] ==
          customer.pricingId);
      if (lineItem == null) {
        lineItems.add({
          "price_data": {
            "tax_behavior": "inclusive",
            "currency": "eur",
            "product_data": {
              "name": pricing.displayName,
              "metadata": {"pricing_id": pricing.id}
            },
            "unit_amount": pricing.priceCents
          },
          "quantity": 1,
          "tax_rates": [pricing.stripeTaxRateId],
        });
      } else {
        lineItem["quantity"] += 1;
      }
    }
    return lineItems;
  }

  Map<String, TourTypePricing> _getPricingsById(
      List<TourTypePricing> pricings) {
    Map<String, TourTypePricing> toReturn = {};
    for (final p in pricings) {
      toReturn.addAll({p.id: p});
    }
    return toReturn;
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
