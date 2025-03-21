import 'package:flutter/material.dart';
import 'package:mush_on/services/models.dart';

class CreateTeamProvider extends ChangeNotifier {
  TeamGroup group = TeamGroup(
    teams: [
      Team(
        dogPairs: [
          DogPair(),
          DogPair(),
        ],
      ),
    ],
    date: DateTime.now().toUtc(),
  );

  List<String> duplicateDogs = [];

  changeGlobalName(String newName) {
    group.name = newName;
    notifyListeners();
  }

  changeDistance(double newDistance) {
    group.distance = newDistance;
    notifyListeners();
  }

  changeAllTeams(List<Team> newTeams) {
    group.teams = newTeams;
    notifyListeners();
  }

  addTeam({required int teamNumber}) {
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
    notifyListeners();
  }

  removeTeam({required int teamNumber}) {
    group.teams.removeAt(teamNumber);
    notifyListeners();
  }

  /// Changes the date but leaves the time of day unchanged
  changeDate(DateTime newDate) {
    group.date = DateTime(newDate.year, newDate.month, newDate.day,
        group.date.hour, group.date.minute);
    notifyListeners();
  }

  /// Changes the time of day but leaves the date unchanged
  changeTime(TimeOfDay time) {
    group.date = DateTime(group.date.year, group.date.month, group.date.day,
        time.hour, time.minute);
    notifyListeners();
  }

  changeTeamName(int teamNumber, String newName) {
    group.teams[teamNumber].name = newName;
    notifyListeners();
  }

  addRow({required int teamNumber}) {
    group.teams[teamNumber].dogPairs.add(DogPair());

    notifyListeners();
  }

  removeRow({required int teamNumber, required int rowNumber}) {
    group.teams[teamNumber].dogPairs.removeAt(rowNumber);
    notifyListeners();
  }

  changeDog(
      {required String newName,
      required int teamNumber,
      required int rowNumber,
      required int dogPosition}) {
    if (dogPosition == 0) {
      group.teams[teamNumber].dogPairs[rowNumber].firstDog = Dog(name: newName);
    } else if (dogPosition == 1) {
      group.teams[teamNumber].dogPairs[rowNumber].secondDog =
          Dog(name: newName);
    }
    updateDuplicateDogs();
    notifyListeners();
  }

  updateDuplicateDogs() {
    duplicateDogs = [];
    Map<String, int> dogCounts = {};

    // Count occurrences of each dog
    for (Team team in group.teams) {
      List<DogPair> rows = team.dogPairs;
      for (DogPair row in rows) {
        String? firstDog = row.firstDog?.name;
        String? secondDog = row.secondDog?.name;

        if (firstDog != null && firstDog.isNotEmpty) {
          dogCounts[firstDog] = (dogCounts[firstDog] ?? 0) + 1;
        }

        if (secondDog != null && secondDog.isNotEmpty) {
          dogCounts[secondDog] = (dogCounts[secondDog] ?? 0) + 1;
        }
      }
    }

    // Add to duplicateDogs if count > 1
    dogCounts.forEach((dog, count) {
      if (count > 1) {
        duplicateDogs.add(dog);
      }
    });

    notifyListeners();
  }

  String createTeamsString() {
    String stringTeams = "${group.name}\n\n";
    for (Team team in group.teams) {
      stringTeams = stringTeams + stringifyTeam(team);
      stringTeams = "$stringTeams\n";
    }
    stringTeams = stringTeams.substring(0, stringTeams.length - 2);
    return stringTeams;
  }

  String stringifyTeam(Team team) {
    String streamTeam = team.name;
    String dogPairs = stringifyDogPairs(team.dogPairs);
    return "$streamTeam$dogPairs\n";
  }

  String stringifyDogPairs(List<DogPair> teamDogs) {
    String dogList = "";
    for (DogPair dogPair in teamDogs) {
      dogList = "$dogList\n${dogPair.firstName} - ${dogPair.secondName}";
    }
    return dogList;
  }
}
