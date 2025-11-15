import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'teamgroup.g.dart';
part 'teamgroup.freezed.dart';

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
  yield* snapshots.map(
    (snapshot) {
      return snapshot.docs.map(
        (doc) {
          return Team.fromJson(
            doc.data(),
          );
        },
      ).toList();
    },
  );
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

@riverpod
Future<List<TeamGroupWorkspace>> teamGroupsWorkspaceFromDateRange(Ref ref,
    {required DateTime start, required DateTime end}) async {
  final account = await ref.watch(accountProvider.future);
  final path = "accounts/$account/data/teams/history";
  final db = FirebaseFirestore.instance;

  // Step 1: Get all team groups
  final reference = db
      .collection(path)
      .where("date", isGreaterThanOrEqualTo: start)
      .where("date", isLessThanOrEqualTo: end);
  final snapshot = await reference.get();
  final teamGroups = snapshot.docs;

  // Step 2: Get all teams in parallel
  final teamsForTeamgroup = await Future.wait(teamGroups.map((teamGroup) => db
      .collection("accounts/$account/data/teams/history/${teamGroup.id}/teams")
      .get()));

  // Step 3: Build list of all team references for dog pairs fetch
  final allTeamRefs = <TeamReference>[];
  for (final (i, teamGroup) in teamGroups.indexed) {
    final teams = teamsForTeamgroup[i].docs;
    for (final team in teams) {
      allTeamRefs.add(TeamReference(
        teamGroupId: teamGroup.id,
        teamId: team.id,
      ));
    }
  }

  // Step 4: Fetch all dog pairs in parallel
  final dogPairsResults = await Future.wait(allTeamRefs.map(
      (ref) => getDogPairsReference(ref.teamGroupId, ref.teamId, account)));

  // Step 5: Build lookup map for dog pairs
  final dogPairsMap = <String, Map<String, List<DogPairWorkspace>>>{};
  for (final result in dogPairsResults) {
    dogPairsMap.putIfAbsent(result.teamGroupId, () => {});
    dogPairsMap[result.teamGroupId]![result.teamId] = result.dogPairs
        .map((dp) => DogPairWorkspace(
            id: dp.id, firstDogId: dp.firstDogId, secondDogId: dp.secondDogId))
        .toList();
  }

  // Step 6: Build final structure in one pass
  final toReturn = <TeamGroupWorkspace>[];
  for (final (i, teamGroupDoc) in teamGroups.indexed) {
    final tg = TeamGroup.fromJson(teamGroupDoc.data());
    final teamDocs = teamsForTeamgroup[i].docs;

    final teamsWorkspace = teamDocs.map((teamDoc) {
      final team = Team.fromJson(teamDoc.data());
      final dogPairs = dogPairsMap[tg.id]?[team.id] ?? [];

      return TeamWorkspace(
        id: team.id,
        name: team.name,
        capacity: team.capacity,
        dogPairs: dogPairs,
      );
    }).toList();

    toReturn.add(TeamGroupWorkspace(
      date: tg.date,
      runType: tg.runType,
      notes: tg.notes,
      name: tg.name,
      id: tg.id,
      teams: teamsWorkspace,
      distance: tg.distance,
    ));
  }

  return toReturn;
}

Future<DogPairsReference> getDogPairsReference(
    String teamGroupId, String teamId, String account) async {
  final db = FirebaseFirestore.instance;
  final path =
      "accounts/$account/data/teams/history/$teamGroupId/teams/$teamId/dogPairs";
  final collection = db.collection(path);
  final snap = await collection.get();
  final docs = snap.docs;
  return DogPairsReference(
      teamId: teamId,
      teamGroupId: teamGroupId,
      dogPairs: docs.map((doc) => DogPair.fromJson(doc.data())).toList());
}

@freezed

/// Used to store the team group id and the team id for future fetching.
sealed class TeamReference with _$TeamReference {
  const factory TeamReference({
    required String teamGroupId,
    required String teamId,
  }) = _TeamReference;
}

@freezed
sealed class DogPairsReference with _$DogPairsReference {
  const factory DogPairsReference({
    required String teamGroupId,
    required String teamId,
    required List<DogPair> dogPairs,
  }) = _DogPairsReference;
}
