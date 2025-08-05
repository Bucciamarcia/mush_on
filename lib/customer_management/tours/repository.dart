import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';
import 'models.dart';

class ToursRepository {
  final String account;
  final logger = BasicLogger();
  final _db = FirebaseFirestore.instance;
  ToursRepository({required this.account});

  /// Sets a tour type, replacing the old version or creating a new one.
  Future<void> setTour(TourType tour) async {
    String path = "accounts/$account/data/bookingManager/tours";
    try {
      await _db.collection(path).doc(tour.id).set(tour.toJson());
    } catch (e, s) {
      logger.error("Couldn't set tour.", error: e, stackTrace: s);
      rethrow;
    }
  }
}
