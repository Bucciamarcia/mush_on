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

  /// Sets all the customers for this group in a batch operation.
  Future<void> setCustomers(List<Customer> customers) async {
    String path = "accounts/$account/data/bookingManager/customers";
    var batch = _db.batch();
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
