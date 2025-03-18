import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/create_team/provider.dart';
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
    final FirebaseFirestore db = FirebaseFirestore.instance;
    List<Map<String, dynamic>> cleanTeams =
        _modifyTeamsForDb(teamProvider.group.teams);
    var data = {
      "date": teamProvider.group.date.toUtc(),
      "name": teamProvider.group.name,
      "notes": teamProvider.group.notes,
      "teams": cleanTeams
    };

    if (snapshot.docs.isEmpty) {
      var ref = db.collection("data").doc("teams").collection("history");

      ref.add(data);
    } else {
      var ref = db
          .collection("data")
          .doc("teams")
          .collection("history")
          .doc(snapshot.docs[0].id);
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
    var ref = db.collection("data").doc("teams").collection("history");
    var query = ref.where(
      "date",
      isEqualTo: teamProvider.group.date.toUtc(),
    );
    QuerySnapshot snapshot = await query.get();
    return snapshot;
  }
}
