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
}
