import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dogpair.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/models/team.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:mush_on/shared/distance_warning_widget/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod

/// The teamgroup that is being built.
class CreateTeamGroup extends _$CreateTeamGroup {
  @override
  TeamGroup build(TeamGroup? teamGroup) {
    if (teamGroup == null) {
      return TeamGroup(date: DateTime.now(), teams: [
        Team(
          dogPairs: [
            DogPair(),
            DogPair(),
          ],
        ),
      ]);
    } else {
      return teamGroup;
    }
  }

  /// Change name of the teamgroup.
  void changeName(String newName) {
    state = state.copyWith(name: newName);
  }

  void changeNotes(String newNotes) {
    state = state.copyWith(notes: newNotes);
  }

  void changeDate(DateTime newDate) {
    state = state.copyWith(date: newDate);
  }

  void changeDistance(double newDistance) {
    state = state.copyWith(distance: newDistance);
  }

  /// Changes a dog in a certain position with another dog.
  void changePosition({
    required String dogId,
    required int teamNumber,
    required int rowNumber,
    required int positionNumber,
  }) {
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
    var teamToEdit = state.teams[teamNumber];
    var newRows = List<DogPair>.from(state.teams[teamNumber].dogPairs);
    newRows.add(DogPair());
    var editedTeam = teamToEdit.copyWith(dogPairs: newRows);
    var newTeams = List<Team>.from(state.teams);
    newTeams.removeAt(teamNumber);
    newTeams.insert(teamNumber, editedTeam);
    state = state.copyWith(teams: newTeams);
  }

  void addTeam({required int teamNumber}) {
    var newTeams = List<Team>.from(state.teams);
    newTeams.insert(
        teamNumber, Team(dogPairs: [DogPair(), DogPair(), DogPair()]));
    state = state.copyWith(teams: newTeams);
  }

  void removeTeam({required int teamNumber}) {
    var newTeams = List<Team>.from(state.teams);
    newTeams.removeAt(teamNumber);
    state = state.copyWith(teams: newTeams);
  }
}

@riverpod
List<DogNote> dogNotes(Ref ref) {
  final logger = BasicLogger();
  final dogs = ref.watch(dogsProvider).value ?? [];
  final distanceWarnings =
      ref.watch(distanceWarningsProvider(latestDate: null)).value ?? [];
  final duplicateDogs = ref.watch(duplicateDogsProvider);

  // Use a Map for O(1) lookups instead of List
  final dogNotesMap = <String, DogNote>{};

  // Process distance warnings
  for (final warning in distanceWarnings) {
    final noteType =
        warning.distanceWarning.distanceWarningType == DistanceWarningType.soft
            ? DogNoteType.distanceWarning
            : DogNoteType.distanceError;

    final details = "${warning.distanceRan.toStringAsFixed(0)}/"
        "${warning.distanceWarning.distance}km "
        "${warning.distanceWarning.daysInterval}d";

    dogNotesMap.update(
      warning.dog.id,
      (existing) => existing.copyWith(
        dogNoteMessage: [
          ...existing.dogNoteMessage,
          DogNoteMessage(type: noteType, details: details),
        ],
      ),
      ifAbsent: () => DogNote(
        dogId: warning.dog.id,
        dogNoteMessage: [DogNoteMessage(type: noteType, details: details)],
      ),
    );
  }

  // Process duplicate dogs
  for (final dogId in duplicateDogs) {
    dogNotesMap.update(
      dogId,
      (existing) => existing.copyWith(
        dogNoteMessage: [
          ...existing.dogNoteMessage,
          DogNoteMessage(type: DogNoteType.duplicate),
        ],
      ),
      ifAbsent: () => DogNote(
        dogId: dogId,
        dogNoteMessage: [DogNoteMessage(type: DogNoteType.duplicate)],
      ),
    );
  }

  return dogNotesMap.values.toList();
}

@riverpod

/// The ids of the dogs that are currently running.
///
/// Used to make the unavailable in the dropdown selection.
class RunningDogs extends _$RunningDogs {
  @override
  List<String> build(TeamGroup group) {
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
