import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
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
