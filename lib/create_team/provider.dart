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
    notifyListeners();
  }
}
