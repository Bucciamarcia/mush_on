import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
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

/// Returns a list of customer groups that have the same date and time as the input.
///
/// Used to get the customer groups that can be assigned to a booking.
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
