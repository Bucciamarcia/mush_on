import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';

class StatsDb extends FirestoreService {
  /// Gets all the TeamGroups after a specific date.
  /// If no date is specified, returns all TeamGroups.
  /// Items are ordered from newest to oldest.
  Future<List<TeamGroup>> getTeamsAfterDate({DateTime? cutoffDate}) async {
    String account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/teams/history";
    QuerySnapshot<Map<String, dynamic>> ref;
    if (cutoffDate == null) {
      ref = await db.collection(path).get();
    } else {
      ref = await db
          .collection(path)
          .where("date", isGreaterThanOrEqualTo: cutoffDate)
          .get();
    }
    var data = ref.docs.map((s) => s.data());
    var teamGroups = data.map((d) => TeamGroup.fromJson(d));
    List<TeamGroup> tgList = teamGroups.toList();

    // Put in ascending order, from newest to oldest based on the "date" parameter
    tgList.sort((a, b) => b.date.compareTo(a.date));
    return tgList;
  }
}
