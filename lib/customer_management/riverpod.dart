import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod

/// Returns a list of teamgroups that have he same date and time as the input
Stream<List<TeamGroup>> teamGroupsByDate(Ref ref, DateTime date) async* {
  String account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;

  var collection = db
      .collection("accounts/$account/data/teams/history")
      .where("date", isEqualTo: date);

  yield* collection.snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => TeamGroup.fromJson(doc.data())).toList(),
      );
}

@riverpod
Future<CustomerGroup> customerGroupById(Ref ref, String id) async {
  String account = await ref.watch(accountProvider.future);
  var db = FirebaseFirestore.instance;
  var collection =
      db.collection("accounts/$account/data/bookingManager/customerGroups");
  var doc = collection.doc(id);
  try {
    var snapshot = await doc.get();
    var data = snapshot.data();
    return CustomerGroup.fromJson(data ?? {});
  } catch (e, s) {
    BasicLogger().error(
      "Error getting customer group by id: $id",
      error: e,
      stackTrace: s,
    );
    rethrow;
  }
}

@riverpod

/// Returns a list of customer groups that have the same date and time as the input.
Stream<List<CustomerGroup>> customerGroupsByDate(
    Ref ref, DateTime date) async* {
  BasicLogger().debug("To search: $date");
  String account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  var collection = db
      .collection("accounts/$account/data/bookingManager/customerGroups")
      .where("datetime", isEqualTo: date);
  yield* collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => CustomerGroup.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}

@riverpod

/// Returns a list of customer groups that have the same date.
Stream<List<CustomerGroup>> customerGroupsByDay(Ref ref, DateTime date) async* {
  String account = await ref.watch(accountProvider.future);
  DateTime day = DateTime(date.year, date.month, date.day);
  final db = FirebaseFirestore.instance;
  var collection = db
      .collection("accounts/$account/data/bookingManager/customerGroups")
      .where("datetime", isGreaterThanOrEqualTo: day)
      .where(
        "datetime",
        isLessThan: day.add(
          const Duration(days: 1),
        ),
      );
  yield* collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => CustomerGroup.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}

@riverpod

/// Gets all the customers assigned to a certain booking

Stream<List<Customer>> customersByBookingId(Ref ref, String bookingId) async* {
  String account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  var collection = db
      .collection("accounts/$account/data/bookingManager/customers")
      .where("bookingId", isEqualTo: bookingId);
  yield* collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Customer.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}

@riverpod

/// Gets all the bookings for a certain day
Stream<List<Booking>> bookingsByDay(Ref ref, DateTime date) async* {
  String account = await ref.watch(accountProvider.future);
  DateTime day = DateTime(date.year, date.month, date.day);
  final db = FirebaseFirestore.instance;
  var collection = db
      .collection("accounts/$account/data/bookingManager/bookings")
      .where("date", isGreaterThanOrEqualTo: day)
      .where(
        "date",
        isLessThan: day.add(
          const Duration(days: 1),
        ),
      );
  yield* collection.snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList(),
      );
}

@riverpod
Stream<List<Booking>> bookingsByCustomerGroupId(Ref ref, String id) async* {
  String account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  var collection = db
      .collection("accounts/$account/data/bookingManager/bookings")
      .where("customerGroupId", isEqualTo: id);
  yield* collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Booking.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}

@riverpod

/// Returns the bookings without a customer group assigned, defaulting to 30 days from now.
Stream<List<Booking>> futureBookings(Ref ref,
    {required DateTime? untilDate}) async* {
  String account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  untilDate = untilDate ?? DateTimeUtils.today().add(Duration(days: 30));
  var collection = db
      .collection("accounts/$account/data/bookingManager/bookings")
      .where("date",
          isGreaterThanOrEqualTo: DateTimeUtils.today().add(Duration(days: 1)))
      .where("date", isLessThanOrEqualTo: untilDate);
  yield* collection.snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList(),
      );
}

@riverpod
Stream<List<CustomerGroup>> futureCustomerGroups(Ref ref,
    {required DateTime? untilDate}) async* {
  String account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;
  untilDate = untilDate ?? DateTimeUtils.today().add(Duration(days: 30));
  var collection = db
      .collection("accounts/$account/data/bookingManager/customerGroups")
      .where("datetime",
          isGreaterThanOrEqualTo: DateTimeUtils.today().add(Duration(days: 1)))
      .where("datetime", isLessThanOrEqualTo: untilDate);
  yield* collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => CustomerGroup.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}
