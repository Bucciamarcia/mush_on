import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'stripe_models.dart';

class StripeRepository {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  final String account;
  static BasicLogger logger = BasicLogger();

  StripeRepository({required this.account});

  /// Sets the accountId. IMPORTANT: defaults to overriding everything else, not to merge.
  Future<void> saveStripeAccountId(String id, bool isActive) async {
    String path = "accounts/$account/integrations/stripe/accounts/$id";
    final doc = db.doc(path);
    try {
      await doc
          .set(StripeConnection(accountId: id, isActive: isActive).toJson());
    } catch (e, s) {
      logger.error("Couldn't save Stripe account ID", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<String> changeStripeIntegrationActivation(
      {required bool newStatus, required String stripeAccountId}) async {
    try {
      await functions
          .httpsCallable("activate_stripe_connection")
          .call({"account": account, "stripeAccountId": stripeAccountId});
      return "OK";
    } catch (e, s) {
      logger.error("Couldn't change Stripe integration activation status",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> removeStripeAccountId() async {
    final path = "accounts/$account/integrations/stripe/accounts";
    final ref = db.collection(path).where("isActive", isEqualTo: true);
    final snapshot = await ref.get();
    final docs = snapshot.docs;
    if (docs.isEmpty) return;
    if (docs.length > 1) {
      throw Exception("There is more than one active stripe connection!");
    }
    final doc = docs.first;
    final docId = doc.id;
    final docPath = "$path/$docId";
    final docRef = db.doc(docPath);
    try {
      await docRef.set({"isActive": false}, SetOptions(merge: true));
    } catch (e, s) {
      logger.error("Couldn't set doc for remove stripe account id",
          error: e, stackTrace: s);
    }
  }

  Stream<StripeConnection?> stripeConnection() async* {
    String path = "accounts/$account/integrations/stripe/accounts";
    final ref = db.collection(path).where("isActive", isEqualTo: true);
    yield* ref.snapshots().map((snapshot) {
      final docs = snapshot.docs;
      if (docs.isEmpty) return null;
      if (docs.length > 1) {
        throw Exception("There is more than one active stripe connection!");
      }
      return StripeConnection.fromJson(docs.first.data());
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
      BookingManagerKennelInfo data) async {
    String path = "accounts/$account/data/bookingManager";
    final doc = db.doc(path);
    try {
      await doc.set(data.toJson());
    } catch (e, s) {
      logger.error("Couldn't save Booking Manager kennel info",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Removes the Stripe connection and the payment page settings data.
  Future<void> removeBookingManagerKennelInfo() async {
    String path = "accounts/$account/data/bookingManager";
    final doc = db.doc(path);
    try {
      await doc.delete();
    } catch (e, s) {
      logger.error("Couldn't remove Booking Manager kennel info",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> saveKennelImage(File file) async {
    String path = "accounts/$account/bookingManager/banner";
    final ref = storage.ref(path);
    try {
      await ref.putFile(file);
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
          "Successfully fetched image data, size: ${data?.length ?? 0} bytes");
      return data;
    } catch (e, s) {
      logger.debug("No image found or error occurred: $e",
          error: e, stackTrace: s);
      return null;
    }
  }
}
