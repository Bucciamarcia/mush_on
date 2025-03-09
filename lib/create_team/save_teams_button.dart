import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:provider/provider.dart';

class SaveTeamsButton extends StatelessWidget {
  const SaveTeamsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CreateTeamProvider teamProvider = context.watch<CreateTeamProvider>();
    return ElevatedButton(
      onPressed: () {
        try {
          saveToDb(teamProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Teams saved"),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error saving team"),
            ),
          );
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
    final FirebaseFirestore db = FirebaseFirestore.instance;
    var data = {
      "date": teamProvider.date,
      "name": teamProvider.name,
      "notes": teamProvider.notes,
      "teams": teamProvider.teams
    };

    var ref = db.collection("data").doc("teams").collection("history");

    try {
      ref.add(data);
    } catch (e) {
      rethrow;
    }
  }
}
