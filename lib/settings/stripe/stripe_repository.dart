import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'stripe_models.dart';

class StripeRepository {
  final FirebaseFirestore db;
  final FirebaseStorage storage;
  final FirebaseFunctions functions;
  final String account;
  static BasicLogger logger = BasicLogger();

  StripeRepository({
    required this.account,
    FirebaseFunctions? functions,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : db = firestore ?? FirebaseFirestore.instance,
       storage = storage ?? FirebaseStorage.instance,
       functions =
           functions ?? FirebaseFunctions.instanceFor(region: "europe-north1");

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
    try {
      await disconnectActiveStripeConnection();
    } catch (e, s) {
      logger.error(
        "Couldn't remove Stripe account ID",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> _callStripeCommand(
    String callableName,
    Map<String, dynamic> payload,
  ) async {
    final result = await functions.httpsCallable(callableName).call(payload);
    final data = result.data as Map<String, dynamic>;
    final error = data["error"];
    if (error != null) {
      throw Exception("Error not null: ${error.toString()}");
    }
  }

  Future<void> setSelectedMode(StripeMode mode) async {
    try {
      await _callStripeCommand("set_selected_stripe_mode", {
        "account": account,
        "stripeMode": mode.name,
      });
    } catch (e, s) {
      logger.error("Couldn't set Stripe mode", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> reconnectStripeAccount({
    required String accountId,
    required StripeMode stripeMode,
  }) async {
    try {
      await _callStripeCommand("reconnect_stripe_account", {
        "account": account,
        "accountId": accountId,
        "stripeMode": stripeMode.name,
      });
    } catch (e, s) {
      logger.error(
        "Couldn't reconnect Stripe account",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> deleteStripeAccount({required String accountId}) async {
    try {
      await _callStripeCommand("delete_stripe_account", {
        "account": account,
        "accountId": accountId,
      });
    } catch (e, s) {
      logger.error("Couldn't delete Stripe account", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> disconnectStripeAccount({required StripeMode stripeMode}) async {
    try {
      await _callStripeCommand("disconnect_stripe_account", {
        "account": account,
        "stripeMode": stripeMode.name,
      });
    } catch (e, s) {
      logger.error(
        "Couldn't disconnect Stripe integration",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Flips the `isActive` parameter for stripe integration.
  Future<bool> changeStripeIntegrationActivation(bool newStatus) async {
    try {
      final result = await functions
          .httpsCallable("change_stripe_integration_activation")
          .call({"account": account, "isActive": newStatus});
      final data = result.data as Map<String, dynamic>;
      final error = data["error"];
      if (error != null) {
        throw Exception("Error not null: ${error.toString()}");
      }
      return true;
    } catch (e, s) {
      logger.error(
        "Couldn't change Stripe integration activation status",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> disconnectActiveStripeConnection() async {
    try {
      await _callStripeCommand("disconnect_stripe_account", {
        "account": account,
      });
    } catch (e, s) {
      logger.error(
        "Couldn't disconnect Stripe integration",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<bool> finalizeStripeOnboarding({
    required String attemptId,
    required String token,
  }) async {
    try {
      final result = await functions
          .httpsCallable("finalize_stripe_onboarding")
          .call({"account": account, "attemptId": attemptId, "token": token});
      final data = result.data as Map<String, dynamic>;
      final error = data["error"];
      if (error != null) {
        throw Exception("Error not null: ${error.toString()}");
      }
      return data["isActive"] == true;
    } catch (e, s) {
      logger.error(
        "Couldn't finalize Stripe onboarding",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<String> createStripeAccount({required StripeMode stripeMode}) async {
    try {
      final result = await functions
          .httpsCallable("stripe_create_account")
          .call({"account": account, "stripeMode": stripeMode.name});
      final data = result.data as Map<String, dynamic>;
      final error = data["error"];
      if (error != null) {
        throw Exception(error);
      }
      final accountId = data["account"];
      if (accountId == null) {
        throw Exception("Account ID is null");
      }
      return accountId as String;
    } catch (e, s) {
      logger.error("Couldn't create Stripe account", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<String> createStripeAccountLink({
    required StripeMode stripeMode,
  }) async {
    try {
      final result = await functions
          .httpsCallable("stripe_create_account_link")
          .call({"account": account, "stripeMode": stripeMode.name});
      final data = result.data as Map<String, dynamic>;
      final error = data["error"];
      if (error != null) {
        throw Exception(error);
      }
      final url = data["url"];
      if (url == null) {
        throw Exception("URL is null");
      }
      return url as String;
    } catch (e, s) {
      logger.error(
        "Couldn't create Stripe account link",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<StripeConnectionStatus> getStripeConnectionStatus() async {
    try {
      final result = await functions
          .httpsCallable("get_stripe_connection_status")
          .call({"account": account});
      final data = result.data as Map<String, dynamic>;
      final error = data["error"];
      if (error != null) {
        throw Exception("Error not null: ${error.toString()}");
      }
      return StripeConnectionStatus.fromJson(data);
    } catch (e, s) {
      logger.error(
        "Couldn't get Stripe connection status",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Stream<StripeConnection?> stripeConnection() async* {
    String path = "accounts/$account/integrations/stripe";
    final doc = db.doc(path);
    yield* doc.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return StripeConnection.fromJson(data);
    });
  }

  Stream<StripeMode> selectedMode() async* {
    String path = "accounts/$account/integrations/stripe";
    final doc = db.doc(path);
    yield* doc.snapshots().map((snapshot) {
      final data = snapshot.data();
      return data?["selectedMode"] == "live"
          ? StripeMode.live
          : StripeMode.test;
    });
  }

  Stream<bool> stripeIntegrationActive() async* {
    String path = "accounts/$account/integrations/stripe";
    final doc = db.doc(path);
    yield* doc.snapshots().map((snapshot) {
      final data = snapshot.data();
      return data?["isActive"] == true;
    });
  }

  Stream<List<StripeAccount>> stripeAccounts({StripeMode? mode}) async* {
    final path = "accounts/$account/integrations/stripe/accounts";
    Query<Map<String, dynamic>> query = db.collection(path);
    if (mode != null) {
      query = query.where("mode", isEqualTo: mode.name);
    }
    yield* query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return StripeAccount.fromJson({
          ...data,
          "accountId": data["accountId"] ?? doc.id,
        });
      }).toList();
    });
  }

  Future<BookingManagerKennelInfo?> getBookingManagerKennelInfo() async {
    String path = "accounts/$account/data/bookingManager";
    final doc = db.doc(path);
    final snapshot = await doc.get();
    final data = snapshot.data();
    if (data == null) return null;
    return BookingManagerKennelInfo.fromJson(data);
  }

  Future<void> saveBookingManagerKennelInfo(
    BookingManagerKennelInfo data,
  ) async {
    String path = "accounts/$account/data/bookingManager";
    final doc = db.doc(path);
    try {
      await doc.set(data.toJson(), SetOptions(merge: true));
    } catch (e, s) {
      logger.error(
        "Couldn't save Booking Manager kennel info",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> saveBookingManagerInvoicingSettings({
    required bool invoicingEnabled,
    required String invoiceLegalName,
    required String invoiceAddress,
    required String invoiceBusinessId,
    required String invoiceNumberPrefix,
    required int nextInvoiceNumber,
  }) async {
    String path = "accounts/$account/data/bookingManager";
    final doc = db.doc(path);
    try {
      await doc.set({
        "invoicingEnabled": invoicingEnabled,
        "invoiceLegalName": invoiceLegalName,
        "invoiceAddress": invoiceAddress,
        "invoiceBusinessId": invoiceBusinessId,
        "invoiceNumberPrefix": invoiceNumberPrefix,
        "nextInvoiceNumber": nextInvoiceNumber,
      }, SetOptions(merge: true));
    } catch (e, s) {
      logger.error(
        "Couldn't save Booking Manager invoicing settings",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> saveKennelImage(Uint8List? fileBytes) async {
    String path = "accounts/$account/bookingManager/banner";
    final ref = storage.ref(path);

    try {
      if (fileBytes != null) {
        await ref.putData(fileBytes);
      } else {
        throw Exception("File bytes are null, cannot upload on web.");
      }
    } catch (e, s) {
      logger.error("Couldn't upload kennel image", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Deletes the kennel banner image.
  Future<void> deleteKennelImage() async {
    String path = "accounts/$account/bookingManager/banner";
    final ref = storage.ref(path);
    try {
      await ref.delete();
    } catch (e, s) {
      logger.error("Couldn't delete kennel image", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<Uint8List?> getKennelImage() async {
    String path = "accounts/$account/bookingManager/banner";
    logger.debug("Fetching kennel image from path: $path");
    final ref = storage.ref(path);
    try {
      final data = await ref.getData();
      logger.debug(
        "Successfully fetched image data, size: ${data?.length ?? 0} bytes",
      );
      return data;
    } catch (e) {
      logger.debug("No image found or error occurred: $e");
      return null;
    }
  }
}
