import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';
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
    if (pricing != null) {
      var coll = _db.collection("$path/${tour.id}/prices");
      var snap = await coll.get();
      for (var s in snap.docs) {
        batch.delete(_db.doc("$path/${tour.id}/prices/${s.id}"));
      }
      for (var p in pricing) {
        batch.set(_db.doc("$path/${tour.id}/prices/${p.id}"), p.toJson());
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

  /// Deletes a tour and all its pricings by the tour id.
  Future<void> deleteTour(String tourId) async {
    String path = "accounts/$account/data/bookingManager/tours";
    var batch = _db.batch();
    batch.delete(_db.doc("$path/$tourId"));

    // Delete tourTypeId for assigned customer groups.
    var cgscol = _db
        .collection("accounts/$account/data/bookingManager/customerGroups")
        .where("tourTypeId", isEqualTo: tourId);
    var cgs = await cgscol.get();
    for (var cg in cgs.docs) {
      var data = cg.data();
      data["tourTypeId"] = null;
      batch.set(
          _db.doc(
              "accounts/$account/data/bookingManager/customerGroups/${cg.id}"),
          data);
    }

    var coll = _db.collection("$path/$tourId/prices");
    var snap = await coll.get();
    for (var s in snap.docs) {
      batch.delete(_db.doc("$path/$tourId/prices/${s.id}"));

      // Delete pricing id in customers.
      var ccol = _db
          .collection("accounts/$account/data/bookingManager/customers")
          .where("pricingId", isEqualTo: s.id);
      var customers = await ccol.get();
      for (var c in customers.docs) {
        var data = c.data();
        data["pricingId"] = null;
        batch.set(
            _db.doc("accounts/$account/data/bookingManager/customers/${c.id}"),
            data);
      }
    }
    try {
      await batch.commit();
    } catch (e, s) {
      logger.error("Failed to delete tour type $tourId",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
