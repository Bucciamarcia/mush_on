import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/services/error_handling.dart';

class SuccessPageRepository {
  final db = FirebaseFirestore.instance;
  final logger = BasicLogger();
  Future<Booking> fetchBooking(String account, String bookingId) async {
    final path = "accounts/$account/data/bookingManager/bookings/$bookingId";
    final doc = db.doc(path);
    try {
      final snapshot = await doc.get();
      final data = snapshot.data();
      if (data == null) {
        throw Exception("Could not find the booking");
      }
      return Booking.fromJson(data);
    } catch (e, s) {
      logger.error("Couldn't get booking", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<List<Customer>> fetchCustomers(
      String account, String bookingId) async {
    try {
      final path = "accounts/$account/data/bookingManager/customers";
      final collection =
          db.collection(path).where("bookingId", isEqualTo: bookingId);
      final snapshot = await collection.get();
      final docs = snapshot.docs;
      return docs.map((doc) => Customer.fromJson(doc.data())).toList();
    } catch (e, s) {
      logger.error("Couldn't get customers", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<CustomerGroup> fetchCg(String account, String cgId) async {
    try {
      final path = "accounts/$account/data/bookingManager/customerGroups";
      final ref = db.collection(path).where("id", isEqualTo: cgId);
      final snapshot = await ref.get();
      final docs = snapshot.docs;
      final doc = docs.first;
      return CustomerGroup.fromJson(doc.data());
    } catch (e, s) {
      logger.error("Couldn't get customer group", error: e, stackTrace: s);
      rethrow;
    }
  }
}
