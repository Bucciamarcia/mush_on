import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dogpair.dart';
import 'package:mush_on/services/models/team.dart';
import 'package:mush_on/services/models/teamgroup.dart';

Future<void> addIdToTeamgroups(String account) async {
  final db = FirebaseFirestore.instance;
  late String path;
  late CollectionReference<Map<String, dynamic>> collection;
  late QuerySnapshot<Map<String, dynamic>> noIdDocs;
  try {
    path = "accounts/$account/data/teams/history";
    collection = db.collection(path);
  } catch (e) {
    return;
  }
  try {
    noIdDocs = await collection.get();
  } catch (e) {
    return;
  }
  final docData = noIdDocs.docs;
  for (var doc in docData) {
    try {
      final obj = TeamGroup.fromJson(doc.data());
      List<Map<String, dynamic>> cleanTeams = _modifyTeamsForDb(obj.teams);
      var data = {
        "date": obj.date,
        "name": obj.name,
        "notes": obj.notes,
        "teams": cleanTeams,
        "distance": obj.distance,
        "id": doc.id
      };
      await db.doc("$path/${doc.id}").set(data);
    } catch (e) {
      return;
    }
  }
}

List<Map<String, dynamic>> _modifyTeamsForDb(List<Team> teams) {
  if (teams.isEmpty == true) {}
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
    BasicLogger().error("N modify for you", error: e, stackTrace: s);
    rethrow;
  }

  return cleanTeams;
}
