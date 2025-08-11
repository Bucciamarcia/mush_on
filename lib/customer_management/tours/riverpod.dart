import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod

/// A list of every tour type.
Stream<List<TourType>> allTourTypes(Ref ref,
    {bool showArchived = false}) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/bookingManager/tours";
  var db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> collection;
  if (showArchived) {
    collection = db.collection(path).snapshots();
  } else {
    collection =
        db.collection(path).where("isArchived", isEqualTo: false).snapshots();
  }
  yield* collection.map(
    (snapshot) => snapshot.docs
        .map(
          (doc) => TourType.fromJson(
            doc.data(),
          ),
        )
        .toList(),
  );
}

@riverpod

/// Gets the tour type object from its id.
Future<TourType> tourTypeById(Ref ref, String id) async {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/bookingManager/tours/$id";
  var db = FirebaseFirestore.instance;
  var doc = db.doc(path);
  var snapshot = await doc.get();
  if (!snapshot.exists) {
    throw Exception("Tour type with id $id does not exist.");
  }
  return TourType.fromJson(snapshot.data()!);
}

@riverpod

/// Gets the tour prices from the tour id.
class TourTypePrices extends _$TourTypePrices {
  @override
  Stream<List<TourTypePricing>> build(String tourId,
      {bool getArchived = false}) async* {
    String account = await ref.watch(accountProvider.future);
    String path = "accounts/$account/data/bookingManager/tours/$tourId/prices";
    var db = FirebaseFirestore.instance;
    late Stream<QuerySnapshot<Map<String, dynamic>>> collection;
    if (getArchived) {
      collection = db.collection(path).snapshots();
    } else {
      collection =
          db.collection(path).where("isArchived", isEqualTo: false).snapshots();
    }
    yield* collection.map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => TourTypePricing.fromJson(
              doc.data(),
            ),
          )
          .toList(),
    );
  }

  /// Add a new pricing option.
  void addPrice(TourTypePricing newPrice) {
    state = state.whenData(
      (data) => [...data, newPrice],
    );
  }

  /// Edits a pricing, matches by id.
  void editPricing(TourTypePricing price) {
    state = state.whenData(
      (data) {
        List<TourTypePricing> toReturn = [];
        for (var d in data) {
          if (d.id != price.id) {
            toReturn.add(d);
          }
        }
        toReturn.add(price);
        return toReturn;
      },
    );
  }
}

@riverpod

/// Returns the pricing model for a specific id
Stream<TourTypePricing?> tourTypePricingById(
    Ref ref, String pricingId, String tourId) async* {
  String account = FirebaseFirestore.instance.app.options.projectId;
  String path =
      "accounts/$account/data/bookingManager/tours/$tourId/prices/$pricingId";
  var db = FirebaseFirestore.instance;
  var doc = db.doc(path);
  yield* doc.snapshots().map(
    (snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return TourTypePricing.fromJson(snapshot.data()!);
    },
  );
}
