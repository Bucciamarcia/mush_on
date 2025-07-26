import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:uuid/uuid.dart';

class RefactorTeamgroups {
  static final logger = BasicLogger();
  final String account;
  final String path;
  final db = FirebaseFirestore.instance;
  RefactorTeamgroups({required this.account})
      : path = "accounts/$account/data/teams/history";

  Future<void> run() async {
    late List<TeamGroup> teamGroups;

    try {
      teamGroups = await _getTeamgroups();
    } catch (e) {
      return;
    }

    if (teamGroups.isEmpty) {
      // Nothing to process
      return;
    }

    var batch = db.batch();

    for (var teamGroup in teamGroups) {
      List<Team> teams = teamGroup.teams;
      for (var (i, team) in teams.indexed) {
        String id = Uuid().v4();
        var data = {
          "name": team.name,
          "id": id,
          "rank": i,
        };
        batch.set(db.doc("$path/${teamGroup.id}/teams/$id"), data);
        for (var (i, dogPair) in team.dogPairs.indexed) {
          String dpid = Uuid().v4();
          var data = {
            "firstDogId": dogPair.firstDogId,
            "secondDogId": dogPair.secondDogId,
            "id": dpid,
            "rank": i,
          };
          batch.set(
              db.doc("$path/${teamGroup.id}/teams/$id/dogPairs/$dpid"), data);
        }
      }
    }

    try {
      logger.info("Dry run");
      await batch.commit();
    } catch (e, s) {
      logger.error("Error committing batch", error: e, stackTrace: s);
      return;
    }
  }

  Future<List<TeamGroup>> _getTeamgroups() async {
    late QuerySnapshot<Map<String, dynamic>> snapshot;
    try {
      snapshot = await db.collection(path).get();
    } catch (e, s) {
      logger.error("Couldn't connect to db", error: e, stackTrace: s);
      rethrow;
    }
    List<TeamGroup> teamGroups =
        snapshot.docs.map((doc) => TeamGroup.fromJson(doc.data())).toList();
    logger.debug("Len of tg found: ${teamGroups.length}");
    return teamGroups;
  }
}
