import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class SaveTeamsButton extends StatelessWidget {
  final CreateTeamProvider teamProvider;
  const SaveTeamsButton({
    super.key,
    required this.teamProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        saveToDb(teamProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("Teams saved"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        teamProvider.changeUnsavedData(false);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
      child: Text(
        "Save Teams",
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  Future<void> saveToDb(CreateTeamProvider teamProvider) async {
    QuerySnapshot<Object?> snapshot = await doesTeamExist();
    DateTime utcDate = teamProvider.group.date.toUtc();
    DateTime dateTimeNoSeconds = DateTime(
        utcDate.year, utcDate.month, utcDate.day, utcDate.hour, utcDate.minute);
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
    String account = await FirestoreService().getUserAccount() ?? "";
    String path = "accounts/$account/data/teams/history";

    if (snapshot.docs.isEmpty) {
      var ref = db.collection(path);

      ref.add(data);
    } else {
      var ref = db.collection(path).doc(snapshot.docs[0].id);
      ref.set(data);
    }
  }

  List<Map<String, dynamic>> _modifyTeamsForDb(List<Team> teams) {
    List<Map<String, dynamic>> cleanTeams = [];

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
          "position_1": dogsRow.firstName,
          "position_2": dogsRow.secondName
        };
      }

      // Add the completed team to the cleanTeams list
      cleanTeams.add(cleanTeam);
    }

    return cleanTeams;
  }

  Future<QuerySnapshot<Object?>> doesTeamExist() async {
    var db = FirebaseFirestore.instance;
    String account = await FirestoreService().getUserAccount() ?? "";
    String path = "accounts/$account/data/teams/history";
    var ref = db.collection(path);
    var query = ref.where(
      "date",
      isEqualTo: teamProvider.group.date.toUtc(),
    );
    QuerySnapshot snapshot = await query.get();
    return snapshot;
  }
}
