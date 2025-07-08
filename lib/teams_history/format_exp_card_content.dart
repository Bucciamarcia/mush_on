import 'package:flutter/material.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/teamgroup.dart';

class FormatObject extends StatelessWidget {
  final TeamGroup item;
  final Map<String, Dog> dogIdMaps;
  const FormatObject(this.item, this.dogIdMaps, {super.key});

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
    List<Team> teams = item.teams;
    String toReturn = item.name;
    for (Team teamItem in teams) {
      toReturn = "$toReturn\n\n${processTeam(teamItem)}";
    }
    return toReturn;
  }

  String processTeam(Team team) {
    String teamString = team.name;
    List<DogPair> teamDogs = team.dogPairs;

    for (DogPair pair in teamDogs) {
      String position_1 = "";
      String position_2 = "";
      if (pair.firstDogId != null) {
        position_1 = dogIdMaps[pair.firstDogId]?.name ?? "";
      }

      if (pair.secondDogId != null) {
        position_2 = dogIdMaps[pair.secondDogId]?.name ?? "";
      }
      teamString = "$teamString\n$position_1 - $position_2";
    }
    return teamString;
  }
}
