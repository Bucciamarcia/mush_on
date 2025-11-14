import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.freezed.dart';
part 'riverpod.g.dart';

@freezed
abstract class StatsDateRange with _$StatsDateRange {
  const factory StatsDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) = _StatsDateRange;

  factory StatsDateRange.initial() => StatsDateRange(
        endDate: DateTimeUtils.today(),
        startDate: DateTimeUtils.today().subtract(const Duration(days: 30)),
      );

  const StatsDateRange._();
}

@riverpod
class StatsDates extends _$StatsDates {
  @override
  StatsDateRange build() {
    return StatsDateRange.initial();
  }

  void changeStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void changeEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }
}

@riverpod
class FilteredDogs extends _$FilteredDogs {
  @override
  List<Dog> build() {
    return [];
  }

  void changeFilteredDogs(List<Dog> newDogs) {
    state = newDogs;
  }
}

/// Pre-fetched data structure to avoid creating hundreds of reactive listeners
class TeamGroupData {
  final Map<String, List<Team>> teamsByGroupId;
  final Map<String, Map<String, List<DogPair>>> dogPairsByGroupAndTeamId;

  TeamGroupData({
    required this.teamsByGroupId,
    required this.dogPairsByGroupAndTeamId,
  });
}

@riverpod
Future<TeamGroupData> prefetchedTeamData(
    Ref ref, List<TeamGroup> teamGroups) async {
  final account = await ref.watch(accountProvider.future);
  final db = FirebaseFirestore.instance;

  // Get all teamGroup IDs we care about
  final teamGroupIds = teamGroups.map((tg) => tg.id).toSet();

  final teamsByGroupId = <String, List<Team>>{};
  final dogPairsByGroupAndTeamId = <String, Map<String, List<DogPair>>>{};

  // Batch the queries to work around Firestore limits and parallelize
  final teamGroupIdsList = teamGroupIds.toList();
  final allTeamsData = <String, List<Team>>{};

  for (int i = 0; i < teamGroupIdsList.length; i += 10) {
    final batch = teamGroupIdsList.skip(i).take(10).toList();

    // Fetch teams for each teamGroup in parallel
    final futures = batch.map((teamGroupId) =>
      db.collection('accounts/$account/data/teams/history/$teamGroupId/teams')
        .orderBy('rank')
        .get()
    ).toList();

    final snapshots = await Future.wait(futures);
    for (int j = 0; j < batch.length; j++) {
      final teams = snapshots[j].docs
          .map((doc) => Team.fromJson(doc.data()))
          .toList();
      allTeamsData[batch[j]] = teams;
    }
  }

  teamsByGroupId.addAll(allTeamsData);

  // Now fetch all dogPairs for all teams in parallel
  final allDogPairsData = <String, Map<String, List<DogPair>>>{};

  for (final teamGroupId in teamGroupIds) {
    final teams = teamsByGroupId[teamGroupId] ?? [];
    if (teams.isEmpty) continue;

    final dogPairFutures = teams.map((team) =>
      db.collection('accounts/$account/data/teams/history/$teamGroupId/teams/${team.id}/dogPairs')
        .orderBy('rank')
        .get()
        .then((snapshot) => MapEntry(
          team.id,
          snapshot.docs.map((doc) => DogPair.fromJson(doc.data())).toList()
        ))
    ).toList();

    final dogPairEntries = await Future.wait(dogPairFutures);
    allDogPairsData[teamGroupId] = Map.fromEntries(dogPairEntries);
  }

  dogPairsByGroupAndTeamId.addAll(allDogPairsData);

  return TeamGroupData(
    teamsByGroupId: teamsByGroupId,
    dogPairsByGroupAndTeamId: dogPairsByGroupAndTeamId,
  );
}
