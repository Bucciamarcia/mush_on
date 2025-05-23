import 'package:flutter/material.dart';
import 'package:mush_on/create_team/model.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

class FakeDogProvider extends ChangeNotifier implements DogProvider {
  List<Dog> _dogs = [];
  @override
  List<Dog> get dogs => _dogs;
  final Map<String, Dog> _dogsById = {};
  @override
  Map<String, Dog> get dogsById => _dogsById;
  String _account = "";
  @override
  String get account => _account;

  FakeDogProvider() {
    _fetchDogs();
    _fetchAccount();
  }
  void _fetchAccount() async {
    _account = "maglelin-experience";
    notifyListeners();
  }

  void _fetchDogs() async {
    _dogs = [
      Dog(name: "Fido", id: "id_Fido", positions: DogPositions(lead: true)),
      Dog(
          name: "Fluffy",
          id: "id_Fluffy",
          positions: DogPositions(swing: true)),
      Dog(
          name: "Wheeler",
          id: "id_Wheeler",
          positions: DogPositions(wheel: true)),
    ];
    _fetchDogsById(_dogs);
    notifyListeners();
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }
}

class FakeCreateTeamProvider extends ChangeNotifier
    implements CreateTeamProvider {
  @override
  BasicLogger logger = BasicLogger();
  @override
  List<DogError> dogErrors = [];
  @override
  TeamGroup group = TeamGroup(
    teams: [
      Team(
        dogPairs: [
          DogPair(),
          DogPair(),
        ],
      ),
    ],
    date: DateTime.now(),
  );
  final Map<String, Dog> _dogsById = {};
  @override
  Map<String, Dog> get dogsById => _dogsById;

  FakeCreateTeamProvider() {
    _fetchDogs();
  }

  void _fetchDogs() async {
    List<Dog> dogs = [
      Dog(name: "Fido", id: "id_Fido", positions: DogPositions(lead: true)),
      Dog(
          name: "Fluffy",
          sex: DogSex.none,
          id: "id_Fluffy",
          positions: DogPositions(swing: true)),
      Dog(
          name: "Wheeler",
          sex: DogSex.none,
          id: "id_Wheeler",
          positions: DogPositions(wheel: true)),
    ];
    _fetchDogsById(dogs);
    notifyListeners();
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }

  @override
  List<String> duplicateDogs = [];
  @override
  bool unsavedData = false;

  @override
  changeGlobalName(String newName) {
    group.name = newName;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeDistance(double newDistance) {
    group.distance = newDistance;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeNotes(String newNotes) {
    group.notes = newNotes;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeAllTeams(List<Team> newTeams) {
    group.teams = newTeams;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  addTeam({required int teamNumber}) {
    try {
      group.teams.insert(
        teamNumber,
        Team(
          dogPairs: [
            DogPair(),
            DogPair(),
            DogPair(),
          ],
        ),
      );
    } catch (e, s) {
      logger.error("Couldn't add team", error: e, stackTrace: s);
    }
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  removeTeam({required int teamNumber}) {
    group.teams.removeAt(teamNumber);
    changeUnsavedData(true);
    notifyListeners();
  }

  /// Changes the date but leaves the time of day unchanged
  @override
  changeDate(DateTime newDate) {
    group.date = DateTime(newDate.year, newDate.month, newDate.day,
        group.date.hour, group.date.minute);
    changeUnsavedData(true);
    notifyListeners();
  }

  /// Changes the time of day but leaves the date unchanged
  @override
  changeTime(TimeOfDay time) {
    group.date = DateTime(group.date.year, group.date.month, group.date.day,
        time.hour, time.minute);
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeTeamName(int teamNumber, String newName) {
    group.teams[teamNumber].name = newName;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  addRow({required int teamNumber}) {
    group.teams[teamNumber].dogPairs.add(DogPair());
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  removeRow({required int teamNumber, required int rowNumber}) {
    group.teams[teamNumber].dogPairs.removeAt(rowNumber);

    notifyListeners();
  }

  @override
  changeDog(
      {required String newId,
      required int teamNumber,
      required int rowNumber,
      required int dogPosition}) {
    try {
      if (dogPosition == 0) {
        group.teams[teamNumber].dogPairs[rowNumber].firstDogId = newId;
      } else if (dogPosition == 1) {
        group.teams[teamNumber].dogPairs[rowNumber].secondDogId = newId;
      }
      updateDuplicateDogs();
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't change dog", error: e, stackTrace: s);
    }
    changeUnsavedData(true);
  }

  @override
  updateDuplicateDogs() {
    duplicateDogs = [];
    Map<String, int> dogCounts = {};

    try {
      // Count occurrences of each dog
      for (Team team in group.teams) {
        List<DogPair> rows = team.dogPairs;
        for (DogPair row in rows) {
          String? firstDog = row.firstDogId;
          String? secondDog = row.secondDogId;

          if (firstDog != null) {
            if (firstDog.isNotEmpty) {
              dogCounts[firstDog] = (dogCounts[firstDog] ?? 0) + 1;
            }
          }

          if (secondDog != null) {
            if (secondDog.isNotEmpty) {
              dogCounts[secondDog] = (dogCounts[secondDog] ?? 0) + 1;
            }
          }
        }
      }
    } catch (e, s) {
      logger.error("Couldn't loop for updateDuplicateDogs",
          error: e, stackTrace: s);
    }

    // Add to duplicateDogs if count > 1
    try {
      dogCounts.forEach((dogId, dogCount) {
        if (dogCount > 1) {
          duplicateDogs.add(dogId);
        }
      });
    } catch (e, s) {
      logger.error("Couldn't add to duplicate dogs", error: e, stackTrace: s);
    }

    notifyListeners();
  }

  @override
  String createTeamsString() {
    String stringTeams = "${group.name}\n\n";
    stringTeams = "$stringTeams${group.notes}\n\n";
    for (Team team in group.teams) {
      stringTeams = stringTeams + stringifyTeam(team);
      stringTeams = "$stringTeams\n";
    }
    stringTeams = stringTeams.substring(0, stringTeams.length - 2);
    return stringTeams;
  }

  @override
  String stringifyTeam(Team team) {
    String streamTeam = team.name;
    String dogPairs = stringifyDogPairs(team.dogPairs);
    return "$streamTeam$dogPairs\n";
  }

  @override
  String stringifyDogPairs(List<DogPair> teamDogs) {
    String dogList = "";
    for (DogPair dogPair in teamDogs) {
      dogList =
          "$dogList\n${dogsById[dogPair.firstDogId]?.name ?? ""} - ${dogsById[dogPair.secondDogId]?.name ?? ""}";
    }
    return dogList;
  }

  /// Defines whether the create team has unsaved data.
  @override
  void changeUnsavedData(bool newCUD) {
    unsavedData = newCUD;
    notifyListeners();
  }
}

TeamGroup loadedTeam = TeamGroup(
    date: DateTime.now(),
    name: "Test name",
    notes: "Test notes",
    distance: 10,
    teams: [
      Team(
          name: "Test team name",
          dogPairs: [DogPair(firstDogId: "id_Fido", secondDogId: "id_Wheeler")])
    ]);
