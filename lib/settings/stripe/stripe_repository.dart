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

  Stream<StripeConnection?> stripeConnection() async* {
    String path = "accounts/$account/integrations/stripe";
    final doc = db.doc(path);
    yield* doc.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return StripeConnection.fromJson(data);
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

  /// Deletes everything in the path.
  Future<void> deleteKennelImage() async {
    String path = "accounts/$account/bookingManager/banner";
    final ref = storage.ref(path);
    try {
      final files = await ref.list();
      for (final file in files.items) {
        await file.delete();
      }
    } catch (e, s) {
      logger.error("Couldn't delete kennel image", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<Uint8List?> getKennelImage() async {
    String path = "accounts/$account/bookingManager/banner";
    final ref = storage.ref(path);
    try {
      final files = await ref.list();
      if (files.items.isEmpty) return null;
      final imageRef = files.items.first;
      return await imageRef.getData();
    } catch (e, s) {
      logger.error("Couldn't get kennel image", error: e, stackTrace: s);
      return null;
    }
  }
}
