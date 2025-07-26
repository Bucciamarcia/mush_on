import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@freezed
sealed class TeamGroupWorkspace with _$TeamGroupWorkspace {
  const factory TeamGroupWorkspace({
    @Default("") String id,

    /// The name of the entire group.
    @Default("") String name,
    required DateTime date,

    /// The distance ran in km.
    /// Used for stats.
    @Default(0) double distance,
    @Default("") String notes,
    @Default([]) List<TeamWorkspace> teams,
  }) = _TeamGroupWorkspace;
}

@freezed
sealed class TeamWorkspace with _$TeamWorkspace {
  const factory TeamWorkspace({
    @Default("") String name,
    required String id,
    @Default([]) List<DogPairWorkspace> dogPairs,
  }) = _TeamWorkspace;
}

@freezed
sealed class DogPairWorkspace with _$DogPairWorkspace {
  const factory DogPairWorkspace({
    String? firstDogId,
    String? secondDogId,
    required String id,
  }) = _DogPairWorkspace;
}

@riverpod
class CanPopTeamGroup extends _$CanPopTeamGroup {
  @override
  bool build() {
    return true;
  }

  void changeState(bool n) {
    state = n;
  }
}

@riverpod

/// The teamgroup that is being built.
class CreateTeamGroup extends _$CreateTeamGroup {
  @override
  TeamGroupWorkspace build(TeamGroup? teamGroup) {
    if (teamGroup == null) {
      return TeamGroupWorkspace(
        date: DateTime.now(),
        id: Uuid().v4(),
      );
    } else {
      //TODO: do teamgroup from id;
      throw Exception("Not yet implemented");
    }
  }

  /// Change name of the teamgroup.
  void changeName(String newName) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.copyWith(name: newName);
  }

  void changeNotes(String newNotes) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.copyWith(notes: newNotes);
  }

  void changeDate(DateTime newDate) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.copyWith(date: newDate);
  }

  void changeDistance(double newDistance) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.copyWith(distance: newDistance);
  }

  /// Changes a dog in a certain position with another dog.
  void changePosition({
    required String dogId,
    required int teamNumber,
    required int rowNumber,
    required int positionNumber,
  }) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    // More efficient update pattern
    state = state.copyWith(
      teams: [
        for (int i = 0; i < state.teams.length; i++)
          if (i == teamNumber)
            state.teams[i].copyWith(
              dogPairs: [
                for (int j = 0; j < state.teams[i].dogPairs.length; j++)
                  if (j == rowNumber)
                    positionNumber == 0
                        ? state.teams[i].dogPairs[j].copyWith(firstDogId: dogId)
                        : state.teams[i].dogPairs[j]
                            .copyWith(secondDogId: dogId)
                  else
                    state.teams[i].dogPairs[j]
              ],
            )
          else
            state.teams[i]
      ],
    );
  }

  void changeTeamName({required int teamNumber, required String newName}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.copyWith(
      teams: [
        for (int i = 0; i < state.teams.length; i++)
          if (i == teamNumber)
            state.teams[i].copyWith(name: newName)
          else
            state.teams[i]
      ],
    );
  }

  void removeRow({required int teamNumber, required int rowNumber}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    state = state.copyWith(
      teams: [
        for (int i = 0; i < state.teams.length; i++)
          if (i == teamNumber)
            state.teams[i].copyWith(
              dogPairs: [
                for (int j = 0; j < state.teams[i].dogPairs.length; j++)
                  if (j != rowNumber) state.teams[i].dogPairs[j]
              ],
            )
          else
            state.teams[i]
      ],
    );
  }

  /// Adds a row at the end of the team.
  void addRow({required int teamNumber}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    var teamToEdit = state.teams[teamNumber];
    var newRows = List<DogPairWorkspace>.from(state.teams[teamNumber].dogPairs);
    newRows.add(DogPairWorkspace(id: Uuid().v4()));
    var editedTeam = teamToEdit.copyWith(dogPairs: newRows);
    var newTeams = List<TeamWorkspace>.from(state.teams);
    newTeams.removeAt(teamNumber);
    newTeams.insert(teamNumber, editedTeam);
    state = state.copyWith(teams: newTeams);
  }

  void addTeam({required int teamNumber}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    var newTeams = List<TeamWorkspace>.from(state.teams);
    newTeams.insert(
      teamNumber,
      TeamWorkspace(dogPairs: [
        DogPairWorkspace(id: Uuid().v4()),
        DogPairWorkspace(id: Uuid().v4()),
        DogPairWorkspace(id: Uuid().v4()),
      ], id: Uuid().v4()),
    );
    state = state.copyWith(teams: newTeams);
  }

  void removeTeam({required int teamNumber}) {
    ref.read(canPopTeamGroupProvider.notifier).changeState(false);
    var newTeams = List<TeamWorkspace>.from(state.teams);
    newTeams.removeAt(teamNumber);
    state = state.copyWith(teams: newTeams);
  }
}

@riverpod

/// The ids of the dogs that are currently running.
///
/// Used to make the unavailable in the dropdown selection.
class RunningDogs extends _$RunningDogs {
  @override
  List<String> build(TeamGroupWorkspace group) {
    // Use a Set for O(1) lookups
    final dogSet = <String>{};

    for (final team in group.teams) {
      for (final row in team.dogPairs) {
        if (row.firstDogId != null) {
          dogSet.add(row.firstDogId!);
        }
        if (row.secondDogId != null) {
          dogSet.add(row.secondDogId!);
        }
      }
    }

    return dogSet.toList();
  }
}

@riverpod
List<String> duplicateDogs(Ref ref) {
  final teamGroup = ref.watch(createTeamGroupProvider(null));

  // Count occurrences in a single pass
  final dogCounts = <String, int>{};

  for (final team in teamGroup.teams) {
    for (final row in team.dogPairs) {
      if (row.firstDogId != null) {
        dogCounts[row.firstDogId!] = (dogCounts[row.firstDogId!] ?? 0) + 1;
      }
      if (row.secondDogId != null) {
        dogCounts[row.secondDogId!] = (dogCounts[row.secondDogId!] ?? 0) + 1;
      }
    }
  }

  // Filter duplicates
  return dogCounts.entries
      .where((entry) => entry.value > 1)
      .map((entry) => entry.key)
      .toList();
}

@riverpod
Future<TeamGroup?> teamGroupById(Ref ref, String id) async {
  BasicLogger().debug("Getting teamgroup by id: $id");
  var db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  var doc = db.doc("accounts/$account/data/teams/history/$id");
  try {
    var snapshot = await doc.get();
    var data = snapshot.data();
    BasicLogger().debug("teamgroup by id: $data");
    if (data == null) {
      throw Exception("Data is empty");
    } else {
      return TeamGroup.fromJson(data);
    }
  } catch (e, s) {
    BasicLogger().error(
      "Error getting team group by id: $id",
      error: e,
      stackTrace: s,
    );
    return null;
  }
}

@riverpod

/// Gets all the customer groups assigned to this teamgroup.
Stream<List<CustomerGroup>> customerGroupsForTeamgroup(
    Ref ref, String teamGroupId) async* {
  final db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/bookingManager/customerGroups";
  final collection =
      db.collection(path).where("teamGroupId", isEqualTo: teamGroupId);
  yield* collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => CustomerGroup.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}
