import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../customer_management/models.dart';
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
class VisibleDates extends _$VisibleDates {
  @override
  List<DateTime> build() {
    return [];
  }

  void change(List<DateTime> newDates) {
    state = newDates;
  }
}

@riverpod
Future<Color> monthCellColor(
    Ref ref, String todayCgIdsAndCapsKey, String account) async {
  try {
    if (todayCgIdsAndCapsKey.isEmpty) return Colors.red;

    final entries = todayCgIdsAndCapsKey.split('|');
    for (final entry in entries) {
      if (entry.isEmpty) continue;
      final parts = entry.split(':');
      if (parts.length != 2) continue;
      final String cgId = parts[0];
      final int capacity = int.tryParse(parts[1]) ?? 0;

      final List<Customer> customers = await ref.watch(
          customersByCustomerGroupIdProvider(cgId, account: account).future);
      if (capacity > customers.length) {
        return Colors.green;
      }
    }
    return Colors.grey;
  } catch (e, s) {
    BasicLogger().error("Couldn't get cell color", error: e, stackTrace: s);
    return Colors.grey;
  }
}
