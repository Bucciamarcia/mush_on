import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@riverpod
Stream<TourType?> tourType(Ref ref,
    {required String account, required String tourId}) async* {
  if (account.isEmpty) {
    yield null;
    return;
  }
  final db = FirebaseFirestore.instance;
  if (account.isEmpty) yield null;
  final String path = "accounts/$account/data/bookingManager/tours/$tourId";
  final doc = db.doc(path);
  yield* doc.snapshots().map((snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    return TourType.fromJson(data);
  });
}

@Riverpod(keepAlive: true)
class Account extends _$Account {
  @override
  String? build() {
    ref.keepAlive();
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
    state = sorted;
  }
}

@riverpod
class SelectedTourId extends _$SelectedTourId {
  @override
  String? build() {
    return null;
  }

  void change(String id) {
    state = id;
  }
}

@riverpod
Future<List<CustomerGroup>> visibleCustomerGroups(Ref ref) async {
  List<DateTime> visibleDates = ref.watch(visibleDatesProvider);
  if (visibleDates.isEmpty) return [];
  String? account = ref.watch(accountProvider);
  final tourId = ref.watch(selectedTourIdProvider);
  if (account == null || account.isEmpty) {
    return [];
  }
  if (tourId == null) {
    BasicLogger().info("NOEP");
    return [];
  }
  final db = FirebaseFirestore.instance;
  final collection = db
      .collection("accounts/$account/data/bookingManager/customerGroups")
      .where("datetime", isGreaterThanOrEqualTo: visibleDates.first)
      .where("datetime",
          isLessThan: visibleDates.last.add(const Duration(days: 1)))
      .where("tourTypeId", isEqualTo: tourId);
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
  if (account == null || account.isEmpty) return const [];
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
  if (account == null || account.isEmpty) return [];
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

@riverpod
class SelectedCustomerGroupInCalendar
    extends _$SelectedCustomerGroupInCalendar {
  @override
  CustomerGroup? build() {
    return null;
  }

  void change(CustomerGroup n) {
    state = n;
  }
}

@riverpod
Future<List<TourTypePricing>> tourTypePricesByTourId(Ref ref,
    {required String tourId, required String account}) async {
  String path = "accounts/$account/data/bookingManager/tours/$tourId/prices";
  var db = FirebaseFirestore.instance;
  final collection =
      await db.collection(path).where("isArchived", isEqualTo: false).get();
  return collection.docs
      .map(
        (doc) => TourTypePricing.fromJson(
          doc.data(),
        ),
      )
      .toList();
}

@riverpod

/// The number of each pricing tier that the customer has selected. Data for stripe.
class BookingDetailsSelectedPricings extends _$BookingDetailsSelectedPricings {
  @override
  List<BookingPricingNumberBooked> build(List<TourTypePricing> pricings) {
    List<BookingPricingNumberBooked> toReturn = [];
    for (final pricing in pricings) {
      toReturn.add(BookingPricingNumberBooked(tourTypePricingId: pricing.id));
    }
    return toReturn;
  }

  void editSinglePricing(String pricingId, int n) {
    final newState = List<BookingPricingNumberBooked>.from(state);
    int toEdit = newState.indexWhere((p) => p.tourTypePricingId == pricingId);
    if (toEdit == -1) return;
    newState[toEdit] = newState[toEdit].copyWith(numberBooked: n);
    state = newState;
  }
}

@freezed

/// A simple utility class that puts together the pricing tier and how many people are booked on it.
sealed class BookingPricingNumberBooked with _$BookingPricingNumberBooked {
  const factory BookingPricingNumberBooked({
    required String tourTypePricingId,
    @Default(0) int numberBooked,
  }) = _BookingPricingNumberBooked;
}
