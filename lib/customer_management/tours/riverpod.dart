import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod

/// A list of every tour type.
Stream<List<TourType>> allTourTypes(Ref ref) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/bookingManager/tours";
  var db = FirebaseFirestore.instance;
  var collection = db.collection(path);
  yield* collection.snapshots().map(
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
///
/// Notice: it gets once, does NOT stream.
class TourTypePrices extends _$TourTypePrices {
  @override
  Future<List<TourTypePricing>> build(String tourId) async {
    String account = await ref.watch(accountProvider.future);
    String path = "accounts/$account/data/bookingManager/tours/$tourId/prices";
    var db = FirebaseFirestore.instance;
    var collection = await db.collection(path).get();
    return collection.docs
        .map(
          (doc) => TourTypePricing.fromJson(
            doc.data(),
          ),
        )
        .toList();
  }

  /// Add a new pricing option.
  void addPrice(TourTypePricing newPrice) {
    state = state.whenData(
      (data) => [...data, newPrice],
    );
  }

  /// Remove a pricing option by id.
  void removePrice(String priceId) {
    state = state.whenData(
      (data) {
        List<TourTypePricing> toReturn = [];
        for (var d in data) {
          if (d.id != priceId) {
            toReturn.add(d);
          }
        }
        return toReturn;
      },
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
