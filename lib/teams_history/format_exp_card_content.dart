import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/riverpod/teamgroup.dart';

class FormatObject extends ConsumerWidget {
  final TeamGroup item;
  final Map<String, Dog> dogIdMaps;
  const FormatObject(this.item, this.dogIdMaps, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        formatMap(ref),
        textAlign: TextAlign.left,
      ),
    );
  }

  String formatMap(WidgetRef ref) {
    List<Team> teams = ref.watch(teamsInTeamgroupProvider(item.id)).value ??
        [Team(id: "adfkshbg", rank: 0)];
    String toReturn = item.name;
    for (Team teamItem in teams) {
      toReturn = "$toReturn\n\n${processTeam(teamItem, ref)}";
    }
    return toReturn;
  }

  String processTeam(Team team, WidgetRef ref) {
    String teamString = team.name;
    List<DogPair> teamDogs =
        ref.watch(dogPairsInTeamProvider(item.id, team.id)).value ?? [];

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
