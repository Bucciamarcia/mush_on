import 'package:flutter/material.dart';

class FormatObject extends StatelessWidget {
  final Map<String, dynamic> item;
  const FormatObject(this.item, {super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        formatMap(),
        textAlign: TextAlign.left,
      ),
    );
  }

  String formatMap() {
    List teams = item["teams"] as List;
    String toReturn = item["name"];

    for (var teamItem in teams) {
      Map<String, dynamic> team = teamItem as Map<String, dynamic>;
      toReturn = "$toReturn\n\n${processTeam(team)}";
    }
    return toReturn;
  }

  String processTeam(Map<String, dynamic> team) {
    String teamString = "Name: ${team["name"]}";
    // Fix here: Handle the dogs data structure safely
    Map<String, dynamic> teamDogs = team["dogs"] as Map<String, dynamic>;

    teamDogs.forEach((key, value) {
      Map<String, dynamic> dogInfo = value as Map<String, dynamic>;

      var position0 = dogInfo["position_1"] ?? "";
      var position1 = dogInfo["position_2"] ?? "";

      teamString = "$teamString\n$position0";
      teamString = "$teamString - $position1";
    });

    return teamString;
  }
}
