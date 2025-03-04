import 'package:flutter/cupertino.dart';

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

  changeDate(DateTime newDate) {
    date = newDate;
    notifyListeners();
  }

  changeTeamName(int teamNumber, String newName) {
    teams[teamNumber]["name"] = newName;
    notifyListeners();
  }

  addRow({required int teamNumber, required int positionNumber}) {
    List<List<String>> dogList = List<List<String>>.from(
      teams[teamNumber]["dogs"] as List<dynamic>,
    );

    dogList.add(["", ""]);

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
}
