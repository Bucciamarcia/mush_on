import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
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
Stream<List<CustomerGroup>> customerGroupsForTour(Ref ref,
    {required String account,
    required String tourTypeId,
    required DateTime intialDate,
    required DateTime finalDate}) async* {
  final logger = BasicLogger();
  logger.debug("adsrfgh");
  final db = FirebaseFirestore.instance;
  final String path = "accounts/$account/data/bookingManager/customerGroups";
  final collection =
      db.collection(path).where("tourTypeId", isEqualTo: tourTypeId);
  try {
    yield* collection.snapshots().map((snapshot) {
      final docs = snapshot.docs;
      logger.info("Found ${docs.length} docs");
      return docs.map((doc) => CustomerGroup.fromJson(doc.data())).toList();
    });
  } catch (e, s) {
    logger.error("Error in fetching customergroups for tour",
        error: e, stackTrace: s);
  }
}
