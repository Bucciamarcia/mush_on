import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/services/error_handling.dart';

class StripeRepository {
  final db = FirebaseFirestore.instance;
  final String account;
  static BasicLogger logger = BasicLogger();

  StripeRepository({required this.account});

  /// Sets the accountId. IMPORTANT: defaults to overriding everything else, not to merge.
  Future<void> saveStripeAccountId(String id, {bool merge = false}) async {
    String path = "accounts/$account/integrations/stripe";
    final doc = db.doc(path);
    try {
      await doc.set({"accountId": id}, SetOptions(merge: merge));
    } catch (e, s) {
      logger.error("Couldn't save Stripe account ID", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Removes the entire document of integrations/stripe
  Future<void> removeStripeAccountId() async {
    String path = "accounts/$account/integrations/stripe";
    final doc = db.doc(path);
    try {
      await doc.delete();
    } catch (e, s) {
      logger.error("Couldn't remove Stripe account ID",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Flips the `isActive` parameter for stripe integration.
  Future<bool> changeStripeIntegrationActivation(bool newStatus) async {
    try {
      final result =
          await FirebaseFunctions.instanceFor(region: "europe-north1")
              .httpsCallable("change_stripe_integration_activation")
              .call({"account": account, "isActive": newStatus});
      final data = result.data as Map<String, dynamic>;
      final error = data["error"];
      if (error != null) {
        throw Exception("Error not null: ${error.toString()}");
      }
      return true;
    } catch (e, s) {
      logger.error("Couldn't change Stripe integration activation status",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
