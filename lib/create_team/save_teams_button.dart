import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

class SaveTeamsButton extends ConsumerWidget {
  final TeamGroup teamGroup;
  static final BasicLogger logger = BasicLogger();
  const SaveTeamsButton({
    super.key,
    required this.teamGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        try {
          String account = await ref.watch(accountProvider.future);
          saveToDb(teamGroup, account);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              content: Text(
                "Teams saved",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          ref.read(canPopTeamGroupProvider.notifier).changeState(true);
        } catch (e, s) {
          logger.error("Couldn't save team to db", error: e, stackTrace: s);
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBar(context, "Couldn't save team to database"),
          );
        }
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary),
      child: Text(
        "Save Teams",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  Future<void> saveToDb(TeamGroup teamGroup, String account) async {
    try {
      DateTime utcDate = teamGroup.date.toUtc();
      DateTime dateTimeNoSeconds = DateTime.utc(utcDate.year, utcDate.month,
          utcDate.day, utcDate.hour, utcDate.minute);
      final FirebaseFirestore db = FirebaseFirestore.instance;
      List<Map<String, dynamic>> cleanTeams =
          _modifyTeamsForDb(teamGroup.teams);
      var data = {
        "date": dateTimeNoSeconds,
        "name": teamGroup.name,
        "notes": teamGroup.notes,
        "teams": cleanTeams,
        "distance": teamGroup.distance,
        "id": teamGroup.id
      };
      String path = "accounts/$account/data/teams/history";

      var ref = db.collection(path).doc(teamGroup.id);
      ref.set(data);
    } catch (e, s) {
      logger.error("Error in saving to db", error: e, stackTrace: s);
      rethrow;
    }
  }

  List<Map<String, dynamic>> _modifyTeamsForDb(List<Team> teams) {
    if (teams.isEmpty == true) {
      logger.warning("Teams is empty in modifyTeamsForDb");
    }
    List<Map<String, dynamic>> cleanTeams = [];

    try {
      for (int i = 0; i < teams.length; i++) {
        Team team = teams[i];

        // Create a new map for this team
        Map<String, dynamic> cleanTeam = {};
        cleanTeam["name"] = team.name;
        cleanTeam["dogs"] = {};

        List<DogPair> dogs = team.dogPairs;
        for (int j = 0; j < dogs.length; j++) {
          var dogsRow = dogs[j];

          // Create the nested map structure
          cleanTeam["dogs"]["row_$j"] = {
            "position_1": dogsRow.firstDogId,
            "position_2": dogsRow.secondDogId
          };
        }

        // Add the completed team to the cleanTeams list
        cleanTeams.add(cleanTeam);
      }
    } catch (e, s) {
      logger.error("Can't loop through teams", error: e, stackTrace: s);
      rethrow;
    }

    return cleanTeams;
  }

  Future<QuerySnapshot<Object?>> doesTeamExist(DateTime newDate) async {
    try {
      var db = FirebaseFirestore.instance;
      String path = "accounts/$account/data/teams/history";
      var ref = db.collection(path);
      var query = ref.where(
        "date",
        isEqualTo: newDate,
      );
      QuerySnapshot snapshot = await query.get();
      return snapshot;
    } catch (e, s) {
      logger.error("Couldn't check if teams exist", error: e, stackTrace: s);
      rethrow;
    }
  }
}
