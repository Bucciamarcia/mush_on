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
