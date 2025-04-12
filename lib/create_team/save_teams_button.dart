import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class SaveTeamsButton extends StatelessWidget {
  final CreateTeamProvider teamProvider;
  static final BasicLogger logger = BasicLogger();
  const SaveTeamsButton({
    super.key,
    required this.teamProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        try {
          saveToDb(teamProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text("Teams saved"),
              behavior: SnackBarBehavior.floating,
            ),
          );
          teamProvider.changeUnsavedData(false);
        } catch (e, s) {
          logger.error("Couldn't save team to db", error: e, stackTrace: s);
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackbar("Couldn't save team to database"),
          );
          teamProvider.changeUnsavedData(true);
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      child: Text(
        "Save Teams",
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Future<void> saveToDb(CreateTeamProvider teamProvider) async {
    try {
      DateTime utcDate = teamProvider.group.date.toUtc();
      DateTime dateTimeNoSeconds = DateTime.utc(utcDate.year, utcDate.month,
          utcDate.day, utcDate.hour, utcDate.minute);
      QuerySnapshot<Object?> snapshot = await doesTeamExist(dateTimeNoSeconds);
      final FirebaseFirestore db = FirebaseFirestore.instance;
      List<Map<String, dynamic>> cleanTeams =
          _modifyTeamsForDb(teamProvider.group.teams);
      var data = {
        "date": dateTimeNoSeconds,
        "name": teamProvider.group.name,
        "notes": teamProvider.group.notes,
        "teams": cleanTeams,
        "distance": teamProvider.group.distance
      };
      String account = await FirestoreService().getUserAccount();
      String path = "accounts/$account/data/teams/history";

      if (snapshot.docs.isEmpty) {
        var ref = db.collection(path);

        ref.add(data);
      } else {
        var ref = db.collection(path).doc(snapshot.docs[0].id);
        ref.set(data);
      }
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
      String account = await FirestoreService().getUserAccount();
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
