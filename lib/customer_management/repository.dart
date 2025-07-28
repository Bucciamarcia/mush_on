import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';
import 'models.dart';

class CustomerManagementRepository {
  final logger = BasicLogger();
  final _db = FirebaseFirestore.instance;
  final String account;
  CustomerManagementRepository({required this.account});

  Future<void> setCustomer(Customer customer) async {
    String path =
        "accounts/$account/data/customerManagement/customers/${customer.id}";
    var doc = _db.doc(path);
    try {
      await doc.set(customer.toJson());
    } catch (e, s) {
      logger.error("Couldn't set customer.", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Adds a new booking, or replaces it ENTIRELY if it already exists.
  Future<void> setBooking(Booking booking) async {
    logger.debug("Called setBooking");
    String path =
        "accounts/$account/data/bookingManager/bookings/${booking.id}";
    var doc = _db.doc(path);
    try {
      await doc.set(booking.toJson());
    } catch (e, s) {
      logger.error("Couldn't set booking.", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Deletes a booking
  Future<void> deleteBooking(String id) async {
    logger.debug("Called deleteBooking for id: $id");
    String path = "accounts/$account/data/bookingManager/bookings/$id";
    var doc = _db.doc(path);
    var batch = _db.batch();
    batch.delete(doc);
    String cusPath = "accounts/$account/data/bookingManager/customers";
    var col =
        await _db.collection(cusPath).where("bookingId", isEqualTo: id).get();
    for (var c in col.docs) {
      batch.delete(_db.doc("$cusPath/${c.id}"));
    }
    try {
      batch.commit();
    } catch (e, s) {
      logger.error("Couldn't delete booking.", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> setCustomerGroup(CustomerGroup cg) async {
    String path =
        "accounts/$account/data/bookingManager/customerGroups/${cg.id}";
    var doc = _db.doc(path);
    try {
      await doc.set(cg.toJson());
    } catch (e, s) {
      logger.error("Couldn't set customer group.", error: e, stackTrace: s);
      rethrow;
    }

    // If the date has changed, we need to remove the bookings frm this customer group.
    var collection = _db
        .collection("accounts/$account/data/bookingManager/bookings")
        .where("customerGroupId", isEqualTo: cg.id);
    var snapshot = await collection.get();
    var docs = snapshot.docs;
    List<Booking> bookings =
        docs.map((doc) => Booking.fromJson(doc.data())).toList();
    List<Booking> wrongBookings =
        bookings.where((booking) => booking.date != cg.datetime).toList();
    if (wrongBookings.isEmpty) {
      return;
    }
    var batch = _db.batch();
    for (var wb in wrongBookings) {
      wb = wb.copyWith(customerGroupId: null);
      batch.set(
          _db.doc("accounts/$account/data/bookingManager/bookings/${wb.id}"),
          wb.toJson());
    }
    batch.commit();
  }

  Future<void> deleteCustomerGroup(String id) async {
    logger.debug("Called deleteCustomerGroup for id: $id");
    String path = "accounts/$account/data/bookingManager/customerGroups/$id";
    var doc = _db.doc(path);
    var batch = _db.batch();
    batch.delete(doc);
    String bookingPath = "accounts/$account/data/bookingManager/bookings";
    var col = await _db
        .collection(bookingPath)
        .where("customerGroupId", isEqualTo: id)
        .get();
    for (var c in col.docs) {
      batch.update(_db.doc("$bookingPath/${c.id}"), {"customerGroupId": null});
    }
    try {
      await batch.commit();
    } catch (e, s) {
      logger.error("Couldn't delete customer group.", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Sets all the customers for this group in a batch operation.
  Future<void> setCustomers(List<Customer> customers, String bookingId) async {
    var batch = _db.batch();
    String path = "accounts/$account/data/bookingManager/customers";
    var snapshot = await _db
        .collection(path)
        .where("bookingId", isEqualTo: bookingId)
        .get();
    for (var c in snapshot.docs) {
      batch.delete(_db.doc("path/${c.id}"));
    }

    for (Customer customer in customers) {
      var docRef = _db.doc("$path/${customer.id}");
      batch.set(docRef, customer.toJson());
    }
    try {
      await batch.commit();
    } catch (e, s) {
      logger.error("Couldn't set customers for group.",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
