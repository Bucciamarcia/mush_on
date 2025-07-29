import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

class SaveTeamsButton extends ConsumerWidget {
  final TeamGroupWorkspace teamGroup;
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
          await saveToDb(teamGroup, account, ref);
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
        "Save team group",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
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

Future<void> saveToDb(
    TeamGroupWorkspace newtg, String account, WidgetRef ref) async {
  final logger = BasicLogger();
  var oldtg = await ref.watch(createTeamGroupProvider(newtg.id).future);
  if (newtg == oldtg) {
    return;
  } else {
    logger.info("Starting save");
    logger.debug(newtg);
    logger.debug(oldtg);
  }
  if (newtg.date != oldtg.date) {
    logger.info("Removing customer gorup");
    logger.debug("Oldtg date: ${oldtg.date}");
    logger.debug("Newtg date: ${newtg.date}");
    _removeCustomerGroups(newtg.id, account, newtg.date);
  }

  final db = FirebaseFirestore.instance;
  var batch = db.batch();
  var newtgObject = newtg.toJson();
  newtgObject.remove("teams");
  var oldtgObject = oldtg.toJson();
  oldtgObject.remove("teams");

  // Updates teamgroup
  if (newtgObject != oldtgObject) {
    batch.set(db.doc("accounts/$account/data/teams/history/${newtg.id}"),
        newtgObject);
  }

  var oldteamsObject = [];
  for (var (i, team) in oldtg.teams.indexed) {
    var tempobj = team.toJson();
    tempobj.addAll({"rank": i});
    oldteamsObject.add(tempobj);
  }
  var newteamsObject = [];
  for (var (i, team) in newtg.teams.indexed) {
    var tempobj = team.toJson();
    tempobj.remove("dogPairs");
    tempobj.addAll({"rank": i});
    newteamsObject.add(tempobj);
  }
  if (oldteamsObject != newteamsObject) {
    // First, delete all teams and their dogpairs.
    for (var team in oldtg.teams) {
      batch.delete(db.doc(
          "accounts/$account/data/teams/history/${newtg.id}/teams/${team.id}"));
      // Delete all dogpairs for this team
      for (var dogPair in team.dogPairs) {
        batch.delete(db.doc(
            "accounts/$account/data/teams/history/${newtg.id}/teams/${team.id}/dogPairs/${dogPair.id}"));
      }
    }
    // Then re-set them all.
    for (var team in newtg.teams) {
      batch.set(
          db.doc(
              "accounts/$account/data/teams/history/${newtg.id}/teams/${team.id}"),
          newteamsObject.firstWhere((o) => o["id"] == team.id));
      // Re-set all dogpairs for this team
      for (var (i, dogPair) in team.dogPairs.indexed) {
        var dogPairData = dogPair.toJson();
        dogPairData.addAll({"rank": i});
        batch.set(
            db.doc(
                "accounts/$account/data/teams/history/${newtg.id}/teams/${team.id}/dogPairs/${dogPair.id}"),
            dogPairData);
      }
    }
  }
  try {
    await batch.commit();
  } catch (e, s) {
    logger.error("Error while saving team group", error: e, stackTrace: s);
    rethrow;
  }
}

Future<void> _removeCustomerGroups(
    String teamId, String account, DateTime newTeamDate) async {
  final logger = BasicLogger();
  logger.debug("Checking remove cg");
  String path = "accounts/$account/data/bookingManager/customerGroups";
  final db = FirebaseFirestore.instance;
  var collection = db.collection(path).where("teamGroupId", isEqualTo: teamId);
  var data = await collection.get();
  List<CustomerGroup> cgs =
      data.docs.map((doc) => CustomerGroup.fromJson(doc.data())).toList();
  logger.debug("Cgs in this tg: ${cgs.length}");
  if (cgs.isEmpty) {
    logger.debug("None to remove");
    return;
  }
  var batch = db.batch();
  for (var cg in cgs) {
    logger.debug("Checing for for id: ${cg.id}");
    logger.debug("cg datetime: ${cg.datetime.toUtc()}");
    logger.debug("New teamdate: $newTeamDate");
    if (cg.datetime.toUtc() != newTeamDate) {
      logger.debug("Need to remove!");
      var newCg = cg.copyWith(teamGroupId: null);
      batch.set(db.doc("$path/${cg.id}"), newCg.toJson());
    }
  }
  await batch.commit();
}
