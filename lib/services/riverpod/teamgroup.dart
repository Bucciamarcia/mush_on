import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'teamgroup.g.dart';

@riverpod

/// Returns the TeamGroup element from its id from the db
Stream<TeamGroup> teamGroupFromId(Ref ref, String id) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/teams/history";
  var db = FirebaseFirestore.instance;
  var collection = db.collection(path);
  var snapshots = collection.where("id", isEqualTo: id).snapshots();
  yield* snapshots
      .map((snapshot) => TeamGroup.fromJson(snapshot.docs.first.data()));
}

@riverpod

/// The list of teams in a teamgroup
Stream<List<Team>> teamsInTeamgroup(Ref ref, String teamgroupId) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/teams/history/$teamgroupId/teams";
  var db = FirebaseFirestore.instance;
  var snapshots = db.collection(path).orderBy("rank").snapshots();
  yield* snapshots.map((snapshot) =>
      snapshot.docs.map((doc) => Team.fromJson(doc.data())).toList());
}

@riverpod

/// The list of dogpairs in a team
Stream<List<DogPair>> dogPairsInTeam(
    Ref ref, String teamgroupId, String teamId) async* {
  String account = await ref.watch(accountProvider.future);
  String path =
      "accounts/$account/data/teams/history/$teamgroupId/teams/$teamId/dogPairs";
  var db = FirebaseFirestore.instance;
  var snapshots = db.collection(path).orderBy("rank").snapshots();
  yield* snapshots.map((snapshot) =>
      snapshot.docs.map((doc) => DogPair.fromJson(doc.data())).toList());
}
