import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
class VisibleDates extends _$VisibleDates {
  @override
  List<DateTime> build() {
    return [];
  }

  void change(List<DateTime> newDates) {
    state = newDates;
  }
}
