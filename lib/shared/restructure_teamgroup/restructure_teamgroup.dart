import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/models.dart';
import 'package:uuid/uuid.dart';

Future<void> restructureTeamgroup(String account) async {
  var db = FirebaseFirestore.instance;
  String path = "accounts/$account/data/teams/history";
  var collection = db.collection(path);
  var snapshot = await collection.get();
  List<TeamGroup> teamgroups = snapshot.docs
      .map(
        (e) => TeamGroup.fromJson(
          e.data(),
        ),
      )
      .toList();
  for (TeamGroup tg in teamgroups) {
    var batch = db.batch();
    for (Team team in tg.teams) {
      String teamId = Uuid().v4();
      String teamPath = "$path/${tg.id}/teams/$teamId";
      Team newTeam = team.copyWith(id: teamId, dogPairs: []);
      var setDoc = db.doc(teamPath);
      batch.set(setDoc, newTeam.toJson());
      for (DogPair dp in team.dogPairs) {
        String dpId = Uuid().v4();
        String dpPath = "$teamPath/dogPairs/$dpId";
        DogPair newDogPair = dp.copyWith(id: dpId);
        var dpDoc = db.doc(dpPath);
        batch.set(dpDoc, newDogPair.toJson());
      }
    }
    batch.commit();
  }
}
