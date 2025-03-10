import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/create_team/provider.dart';

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
        _modifyTeamsForDb(teamProvider.teams);
    var data = {
      "date": teamProvider.date.toUtc(),
      "name": teamProvider.name,
      "notes": teamProvider.notes,
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

  List<Map<String, dynamic>> _modifyTeamsForDb(
      List<Map<String, Object>> teams) {
    List<Map<String, dynamic>> cleanTeams = [];

    for (int i = 0; i < teams.length; i++) {
      Map team = teams[i];

      // Create a new map for this team
      Map<String, dynamic> cleanTeam = {};
      cleanTeam["name"] = team["name"];
      cleanTeam["dogs"] = {};

      List dogs = team["dogs"] as List;
      for (int j = 0; j < dogs.length; j++) {
        List<String> dogsRow = dogs[j].cast<String>();

        // Create the nested map structure
        cleanTeam["dogs"]
            ["row_$j"] = {"position_1": dogsRow[0], "position_2": dogsRow[1]};
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
      isEqualTo: teamProvider.date.toUtc(),
    );
    QuerySnapshot snapshot = await query.get();
    return snapshot;
  }
}
