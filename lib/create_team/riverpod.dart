import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/services/models/dogpair.dart';
import 'package:mush_on/services/models/team.dart';
import 'package:mush_on/services/models/teamgroup.dart';
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

  /// Changes a dog in a certain position with another dog.
  void changePosition(
      {required String dogId,
      required int teamNumber,
      required int rowNumber,
      required int positionNumber}) {
    var newGroups = List<Team>.from(state.teams);
    if (positionNumber == 0) {
      newGroups[teamNumber].dogPairs[rowNumber].firstDogId = dogId;
    } else if (positionNumber == 1) {
      newGroups[teamNumber].dogPairs[rowNumber].secondDogId = dogId;
    }
    state = state.copyWith(teams: newGroups);
  }

  void changeTeamName({required int teamNumber, required String newName}) {
    var newTeams = List<Team>.from(state.teams);
    newTeams[teamNumber].name = newName;
    state = state.copyWith(teams: newTeams);
  }

  void removeRow({required int teamNumber, required int rowNumber}) {
    var newTeams = List<Team>.from(state.teams);
    newTeams[teamNumber].dogPairs.removeAt(rowNumber);
    state = state.copyWith(teams: newTeams);
  }

  /// Adds a row at the end of the team.
  void addRow({required int teamNumber}) {
    var newTeams = List<Team>.from(state.teams);
    newTeams[teamNumber].dogPairs.add(DogPair());
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

/// The ids of the dogs that are currently running.
///
/// Used to make the unavailable in the dropdown selection.
class RunningDogs extends _$RunningDogs {
  @override
  List<String> build() {
    return [];
  }
}

@riverpod
class CreateDogNotes extends _$CreateDogNotes {
  @override
  List<DogNote> build() {
    return [];
  }
}
