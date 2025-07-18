import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';
import 'models.dart';

class CustomerManagementRepository {
  final logger = BasicLogger();
  final _db = FirebaseFirestore.instance;
  final String account;
  CustomerManagementRepository({required this.account});

  /// Adds a new booking, or replaces it ENTIRELY if it already exists.
  Future<void> setBooking(Booking booking) async {
    String path =
        "accounts/$account/data/bookingManager/bookingHistory/${booking.id}";
    var doc = _db.doc(path);
    try {
      await doc.set(booking.toJson());
    } catch (e, s) {
      logger.error("Couldn't set booking.", error: e, stackTrace: s);
      rethrow;
    }
  }
}
