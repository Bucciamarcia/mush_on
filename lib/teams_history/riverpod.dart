import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Stream<List<TeamGroup>> teamGroups(Ref ref,
    {required DateTime earliestDate, DateTime? finalDate}) async* {
  String account = await ref.watch(accountProvider.future);

  final db = FirebaseFirestore.instance;

  var collection = db
      .collection("accounts/$account/data/teams/history")
      .where("date", isGreaterThan: earliestDate);
  if (finalDate != null) {
    collection = collection.where("date", isLessThanOrEqualTo: finalDate);
  }

  yield* collection.snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => TeamGroup.fromJson(doc.data())).toList(),
      );
}
