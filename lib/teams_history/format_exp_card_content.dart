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
    String teamString = "${team["name"]}";
    // Get the dogs data structure
    Map<String, dynamic> teamDogs = team["dogs"] as Map<String, dynamic>;

    // Create a sorted list of the row keys to ensure correct order
    List<String> sortedKeys = teamDogs.keys.toList()
      ..sort((a, b) {
        // Extract numeric part from the key (e.g., "row_0" -> 0)
        int numA = int.parse(a.split('_')[1]);
        int numB = int.parse(b.split('_')[1]);
        return numA.compareTo(numB);
      });

    // Iterate through the keys in sorted order
    for (var key in sortedKeys) {
      Map<String, dynamic> dogInfo = teamDogs[key] as Map<String, dynamic>;
      var position0 = dogInfo["position_1"] ?? "";
      var position1 = dogInfo["position_2"] ?? "";
      teamString = "$teamString\n$position0";
      if (position1.isNotEmpty) {
        teamString = "$teamString - $position1";
      } else {
        teamString = "$teamString -";
      }
    }

    return teamString;
  }
}
