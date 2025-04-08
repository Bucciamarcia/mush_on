import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/teams_history/provider.dart';
import 'package:provider/provider.dart';
import 'format_exp_card_content.dart';

class TeamsHistoryMain extends StatelessWidget {
  const TeamsHistoryMain({super.key});
  @override
  Widget build(BuildContext context) {
    TeamsHistoryProvider historyProvider =
        context.watch<TeamsHistoryProvider>();
    List<TeamGroup> groups = historyProvider.groupObjects;
    return ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          TeamGroup item = groups[index];
          return TeamViewer(item: item);
        });
  }
}

class TeamViewer extends StatelessWidget {
  final TeamGroup item;
  const TeamViewer({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      margin: const EdgeInsets.all(2),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 3),
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Text(
                  DateFormat("dd-MM-yy || HH:mm").format((item.date)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Name with flexible width that can shrink
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              // Load button and delete icon with fixed space
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, "/createteam",
                        arguments: item),
                    child: Text("Load"),
                  ),
                  IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return buildAlertDialog(context);
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
          tilePadding: const EdgeInsets.all(1),
          dense: true,
          children: [FormatObject(item)],
        ),
      ),
    );
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Are you sure?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("This action is irreversible."),
          Text("You will lose all the data related to this group.")
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Go back")),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.red),
          ),
          onPressed: () async {
            bool r = await deleteGroup();
            if (r == true) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Team deleted"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error deleting team"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(
            "Delete group",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  // TODO: This sucks. It needs to find the ID instead of searching by date!
  Future<bool> deleteGroup() async {
    try {
      var db = FirebaseFirestore.instance;
      String? account = await FirestoreService().getUserAccount();

      if (account == null) {
        return false;
      }

      String path = "accounts/$account/data/teams/history";
      var ref = db.collection(path);
      var snapshot = await ref.where("date", isEqualTo: item.date).get();

      if (snapshot.docs.length != 1) {
        return false;
      }
      for (var doc in snapshot.docs) {
        String docPath = "accounts/$account/data/teams/history/${doc.id}";
        await db.doc(docPath).delete();
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
