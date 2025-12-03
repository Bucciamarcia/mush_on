import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/repository.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              String account = await ref.watch(accountProvider.future);
              await saveToDb(teamGroup, account, ref);
              await saveCustomersToDb(teamGroup, account, ref);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  content: Text(
                    "Teams saved",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
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
        ),
        ElevatedButton(
            onPressed: () => ref.invalidate(createTeamGroupProvider),
            child: const Text("Create a new team group")),
      ],
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

  Future<void> saveCustomersToDb(
      TeamGroupWorkspace newtg, String account, WidgetRef ref) async {
    logger.info("Starting sctdb");
    CustomerGroupWorkspace? customerGroup =
        await ref.watch(customerAssignProvider(newtg.id).future);
    if (customerGroup == null) {
      return;
    }
    var repo = CustomerManagementRepository(account: account);
    repo.setAll(customerGroup.customers);
    for (Customer customer in customerGroup.customers) {
      try {
        await repo.setCustomer(customer);
      } catch (e, s) {
        logger.error("Error while saving customer ${customer.id} to db",
            error: e, stackTrace: s);
        rethrow;
      }
    }
  }
}

Future<void> saveToDb(
    TeamGroupWorkspace newtg, String account, WidgetRef ref) async {
  final logger = BasicLogger();
  logger.info("Saving to db the teamgroup workspace");
  var db = FirebaseFirestore.instance;
  var batch = db.batch();
  String path = "accounts/$account/data/teams/history/${newtg.id}";
  var tgdoc = db.doc(path);
  batch.delete(tgdoc);
  var collectionToDelete = await db.collection("$path/teams").get();
  for (var team in collectionToDelete.docs) {
    batch.delete(db.doc("$path/teams/${team.id}"));
    var dppath = "$path/teams/${team.id}/dogPairs";
    var snapshot = await db.collection(dppath).get();
    for (var dp in snapshot.docs) {
      batch.delete(db.doc("$dppath/${dp.id}"));
    }
  }

  _removeCustomerGroups(newtg.id, account, newtg.date);

  var newtgObject = newtg.toJson();
  newtgObject.remove("teams");

  logger.info("starting the save with id: ${newtg.id}");
  batch.set(
      db.doc("accounts/$account/data/teams/history/${newtg.id}"), newtgObject);

  var newteamsObject = [];
  for (var (i, team) in newtg.teams.indexed) {
    var tempobj = team.toJson();
    tempobj.remove("dogPairs");
    tempobj.addAll({"rank": i});
    newteamsObject.add(tempobj);
  }
  // First, delete all teams and their dogpairs.
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
  if (cgs.isEmpty) {
    logger.debug("None to remove");
    return;
  }
  var batch = db.batch();
  for (var cg in cgs) {
    if (cg.datetime.toIso8601String() != newTeamDate.toIso8601String()) {
      logger.debug("Need to remove!");
      var newCg = cg.copyWith(teamGroupId: null);
      batch.set(db.doc("$path/${cg.id}"), newCg.toJson());
    }
  }
  await batch.commit();
}
