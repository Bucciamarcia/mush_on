import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:mush_on/customer_facing/booking_page/repository.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/resellers/home/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:uuid/uuid.dart';

class ResellerRepository {
  final db = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  final logger = BasicLogger();

  Future<String> getStripeUrlReseller(
      {required List<BookedSpot> bookedSpots,
      required CustomerGroup customerGroup,
      required String account,
      required BookingManagerKennelInfo kennelInfo,
      required String resellerName,
      required String resellerId,
      required List<TourTypePricing> pricings,
      required List<Customer> existingCustomers}) async {
    if (_isCustomerGroupFull(bookedSpots, customerGroup, existingCustomers)) {
      throw GroupAlreadyFullException(
          "Trying to book ${bookedSpots.number} in a group of max ${customerGroup.maxCapacity}, but ${existingCustomers.length} already booked");
    } else {
      // Booking is created here
      final booking = Booking(
          id: const Uuid().v4(),
          customerGroupId: customerGroup.id,
          resellerId: resellerId);

      final customersList =
          _fromBookedSpotsToCustomers(bookedSpots, booking.id, resellerName);

      // Adds the tour to the db with status waiting.
      BookingPageRepository(account: account, tourId: customerGroup.tourTypeId!)
          .bookTour(booking, customersList);

      final url = await _getStripeUrl(
          pricings, customersList, account, booking, kennelInfo);
      return url;
    }
  }

  Future<String> _getStripeUrl(
      List<TourTypePricing> pricings,
      List<Customer> customers,
      String account,
      Booking booking,
      BookingManagerKennelInfo kennelInfo) async {
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

  List<Customer> _fromBookedSpotsToCustomers(
      List<BookedSpot> bookedSpots, String bookingId, String resellerName) {
    List<Customer> toReturn = [];
    for (final b in bookedSpots) {
      toReturn.add(Customer(
          id: const Uuid().v4(),
          bookingId: bookingId,
          name: resellerName,
          pricingId: b.pricing.id));
    }
    return toReturn;
  }

  bool _isCustomerGroupFull(List<BookedSpot> bookedSpots,
      CustomerGroup customerGroup, List<Customer> existingCustomers) {
    int existingCustomersNumber = existingCustomers.length;
    int maxCapacity = customerGroup.maxCapacity;
    int tryingToBookNumber = bookedSpots.number;
    if (existingCustomersNumber + tryingToBookNumber > maxCapacity) {
      return true;
    } else {
      return false;
    }
  }
}

class GroupAlreadyFullException implements Exception {
  String cause;
  GroupAlreadyFullException(this.cause);

  @override
  String toString() => "GroupAlreadyFullException: $cause";
}
