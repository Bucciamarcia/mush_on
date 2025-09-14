import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Stream<TourType?> tourType(Ref ref,
    {required String account, required String tourId}) async* {
  final db = FirebaseFirestore.instance;
  final String path = "accounts/$account/data/bookingManager/tours/$tourId";
  final doc = db.doc(path);
  yield* doc.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    return TourType.fromJson(data);
  });
}

@riverpod
class Account extends _$Account {
  @override
  String? build() {
    return null;
  }

  void change(String newAccount) {
    state = newAccount;
  }
}

@riverpod
class VisibleDates extends _$VisibleDates {
  @override
  List<DateTime> build() {
    return [];
  }

  void change(List<DateTime> newDates) {
    final sorted = List<DateTime>.from(newDates);
    sorted.sort((a, b) => a.compareTo(b));
    if (sorted == state) return;
    state = sorted;
  }
}

@riverpod
Future<List<CustomerGroup>> visibleCustomerGroups(Ref ref) async {
  List<DateTime> visibleDates = ref.watch(visibleDatesProvider);
  if (visibleDates.isEmpty) return [];
  String? account = ref.watch(accountProvider);
  final db = FirebaseFirestore.instance;
  final collection = db
      .collection("accounts/$account/data/bookingManager/customerGroups")
      .where("datetime", isGreaterThanOrEqualTo: visibleDates.first)
      .where("datetime",
          isLessThan: visibleDates.last.add(const Duration(days: 1)));
  final snapshot = await collection.get();
  return snapshot.docs
      .map((doc) => CustomerGroup.fromJson(doc.data()))
      .toList();
}

@riverpod
Future<List<Booking>> visibleBookings(Ref ref) async {
  final cgs = await ref.watch(visibleCustomerGroupsProvider.future);
  if (cgs.isEmpty) return const [];

  final account = ref.watch(accountProvider);
  final db = FirebaseFirestore.instance;
  final col = db.collection("accounts/$account/data/bookingManager/bookings");

  final cgIds =
      cgs.map((e) => e.id).where((id) => id.isNotEmpty).toSet().toList();
  if (cgIds.isEmpty) return const [];

  const batchSize = 25;
  final futures = <Future<QuerySnapshot<Map<String, dynamic>>>>[];

  for (var i = 0; i < cgIds.length; i += batchSize) {
    final batch = cgIds.sublist(
        i, i + batchSize > cgIds.length ? cgIds.length : i + batchSize);
    futures.add(col.where("customerGroupId", whereIn: batch).get());
  }

  final snaps = await Future.wait(futures);
  return snaps
      .expand((s) => s.docs)
      .map((d) => Booking.fromJson(d.data()))
      .toList();
}

@riverpod
Future<List<Customer>> visibleCustomers(Ref ref) async {
  final bookings = await ref.watch(visibleBookingsProvider.future);
  if (bookings.isEmpty) return [];
  final account = ref.watch(accountProvider);
  final db = FirebaseFirestore.instance;
  final col = db.collection("accounts/$account/data/bookingManager/customers");
  final bookingIds =
      bookings.map((b) => b.id).where((id) => id.isNotEmpty).toSet().toList();
  const batchSize = 25;
  final futures = <Future<QuerySnapshot<Map<String, dynamic>>>>[];
  for (var i = 0; i < bookingIds.length; i += batchSize) {
    final batch = bookingIds.sublist(i,
        i + batchSize > bookingIds.length ? bookingIds.length : i + batchSize);
    futures.add(col.where("bookingId", whereIn: batch).get());
  }

  final snaps = await Future.wait(futures);
  return snaps
      .expand((s) => s.docs)
      .map((d) => Customer.fromJson(d.data()))
      .toList();
}

@riverpod
Future<Map<DateTime, List<CustomerGroup>>> customerGroupsByDay(Ref ref) async {
  List<DateTime> visibleDates = ref.watch(visibleDatesProvider);
  List<CustomerGroup> customerGroups =
      await ref.watch(visibleCustomerGroupsProvider.future);
  Map<DateTime, List<CustomerGroup>> toReturn = {};
  for (final date in visibleDates) {
    toReturn[date] = customerGroups
        .where((cg) =>
            cg.datetime.year == date.year &&
            cg.datetime.month == date.month &&
            cg.datetime.day == date.day)
        .toList();
  }
  return toReturn;
}

@riverpod
Future<Map<String, List<Booking>>> bookingsByCustomerGroupId(Ref ref) async {
  List<CustomerGroup> customerGroups =
      await ref.watch(visibleCustomerGroupsProvider.future);
  Map<String, List<Booking>> toReturn = {};
  List<Booking> bookings = await ref.watch(visibleBookingsProvider.future);
  for (final cg in customerGroups) {
    toReturn[cg.id] =
        bookings.where((booking) => booking.customerGroupId == cg.id).toList();
  }
  return toReturn;
}

@riverpod
Future<Map<String, List<Customer>>> customersByBookingId(Ref ref) async {
  List<Booking> bookings = await ref.watch(visibleBookingsProvider.future);
  Map<String, List<Customer>> toReturn = {};
  List<Customer> customers = await ref.watch(visibleCustomersProvider.future);
  for (final booking in bookings) {
    toReturn[booking.id] = customers
        .where((customer) => customer.bookingId == booking.id)
        .toList();
  }
  return toReturn;
}

@riverpod

/// How many customers are in each customer group, summing all bookings.
Future<Map<String, int>> customersNumberByCustomerGroupId(Ref ref) async {
  final bookingsByCgId =
      await ref.watch(bookingsByCustomerGroupIdProvider.future);
  final customersByBookingId =
      await ref.watch(customersByBookingIdProvider.future);
  Map<String, int> toReturn = {};
  for (final cgId in bookingsByCgId.keys) {
    final bookings = bookingsByCgId[cgId] ?? [];
    int count = 0;
    for (final booking in bookings) {
      final customers = customersByBookingId[booking.id] ?? [];
      count += customers.length;
    }
    toReturn[cgId] = count;
  }
  return toReturn;
}

@riverpod
class SelectedDateInCalendar extends _$SelectedDateInCalendar {
  @override
  DateTime? build() {
    return null;
  }

  void change(DateTime newDate) {
    state = newDate;
  }
}
