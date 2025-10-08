import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'models.dart';

class ToursRepository {
  final String account;
  final logger = BasicLogger();
  final _db = FirebaseFirestore.instance;
  ToursRepository({required this.account});

  /// Sets a tour type, replacing the old version or creating a new one.
  ///
  /// If a list of pricing is present, it saves that too.
  Future<void> setTour(
      {required TourType tour, List<TourTypePricing>? pricing}) async {
    String path = "accounts/$account/data/bookingManager/tours";
    var batch = _db.batch();
    batch.set(_db.doc("$path/${tour.id}"), tour.toJson());
    String stripeAccountId = await _getStripeAccountId();
    if (pricing != null) {
      try {
        for (var p in pricing) {
          final taxStripe =
              await FirebaseFunctions.instanceFor(region: "europe-north1")
                  .httpsCallable("create_stripe_tax_rate")
                  .call({
            "percentage": p.vatRate * 100,
            "stripeAccountId": stripeAccountId
          });
          final tsData = taxStripe.data as Map<String, dynamic>;
          final error = tsData["error"];
          if (error != null) {
            throw Exception("Error not null: ${error.toString()}");
          }
          final String taxRateId = tsData["tax_id"];
          final pTax = p.copyWith(stripeTaxRateId: taxRateId);
          batch.set(
              _db.doc("$path/${tour.id}/prices/${pTax.id}"), pTax.toJson());
        }
      } catch (e, s) {
        logger.error("Failed to set pricing for tour ${tour.id}",
            error: e, stackTrace: s);
        rethrow;
      }
    }
    try {
      await batch.commit();
    } catch (e, s) {
      logger.error("Failed to set tour type ${tour.id}",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<String> _getStripeAccountId() async {
    String path = "accounts/$account/integrations/stripe";
    final snap = await _db.doc(path).get();
    final data = snap.data();
    if (data == null) {
      throw Exception("No Stripe integration found for account $account");
    }
    final stripeData = StripeConnection.fromJson(data);
    return stripeData.accountId;
  }
}
