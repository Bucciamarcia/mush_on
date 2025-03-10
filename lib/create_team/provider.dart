import 'package:flutter/material.dart';

class CreateTeamProvider extends ChangeNotifier {
  DateTime date = DateTime.now().toUtc();
  String name = "9.30";
  String notes = "";
  List<Map<String, Object>> teams = [
    {
      "name": "1. Tytti",
      "dogs": [
        ["", ""],
        ["", ""],
        ["", ""],
      ]
    }
  ];

  List<String> duplicateDogs = [];

  changeGlobalName(String newName) {
    name = newName;
    notifyListeners();
  }

  changeAllTeams(List<Map<String, Object>> newTeams) {
    teams = newTeams;
    notifyListeners();
  }

  addTeam({required int teamNumber}) {
    Map<String, Object> insElement = {
      "name": "${teamNumber + 1}.",
      "dogs": [
        ["", ""],
        ["", ""],
        ["", ""],
      ]
    };
    teams.insert(teamNumber, insElement);
    notifyListeners();
  }

  removeTeam({required int teamNumber}) {
    teams.removeAt(teamNumber);
    notifyListeners();
  }

  /// Changes the date but leaves the time of day unchanged
  changeDate(DateTime newDate) {
    date = DateTime(
        newDate.year, newDate.month, newDate.day, date.hour, date.minute);
    notifyListeners();
  }

  /// Changes the time of day but leaves the date unchanged
  changeTime(TimeOfDay time) {
    date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    notifyListeners();
  }

  changeTeamName(int teamNumber, String newName) {
    teams[teamNumber]["name"] = newName;
    notifyListeners();
  }

  addRow({required int teamNumber}) {
    List<List<String>> dogList = List<List<String>>.from(
      teams[teamNumber]["dogs"] as List<dynamic>,
    );

    dogList.add(["", ""]);

    teams[teamNumber] = {"name": teams[teamNumber]["name"]!, "dogs": dogList};

    notifyListeners();
  }

  removeRow({required int teamNumber, required int rowNumber}) {
    List<List<String>> dogList = List<List<String>>.from(
      teams[teamNumber]["dogs"] as List<dynamic>,
    );
    dogList.removeAt(rowNumber);
    teams[teamNumber] = {"name": teams[teamNumber]["name"]!, "dogs": dogList};
    notifyListeners();
  }

  changeDog(
      {required String newName,
      required int teamNumber,
      required int rowNumber,
      required int dogPosition}) {
    (teams[teamNumber]["dogs"] as List)[rowNumber][dogPosition] = newName;
    updateDuplicateDogs();
    notifyListeners();
  }

  updateDuplicateDogs() {
    duplicateDogs = [];
    Map<String, int> dogCounts = {};

    // Count occurrences of each dog
    for (Map team in teams) {
      List<List<String>> rows = team["dogs"] as List<List<String>>;
      for (List<String> row in rows) {
        for (String dog in row) {
          // Skip empty strings
          if (dog.isEmpty) continue;

          // Increment dog count
          dogCounts[dog] = (dogCounts[dog] ?? 0) + 1;
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
    String stringTeams = "$name\n\n";
    for (Map<String, Object> team in teams) {
      stringTeams = stringTeams + stringifyTeam(team);
      stringTeams = "$stringTeams\n";
    }
    stringTeams = stringTeams.substring(0, stringTeams.length - 2);
    return stringTeams;
  }

  String stringifyTeam(Map<String, Object> team) {
    String streamTeam = team["name"] as String;
    String dogPairs = stringifyDogPairs(team["dogs"] as List<List<String>>);
    return "$streamTeam$dogPairs\n";
  }

  String stringifyDogPairs(List<List<String>> teamDogs) {
    String dogList = "";
    for (List dogPair in teamDogs) {
      dogList = "$dogList\n${dogPair[0]} - ${dogPair[1]}";
    }
    return dogList;
  }
}
