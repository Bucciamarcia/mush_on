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
              Text(DateFormat("dd-MM-yy || HH:mm").format((item.date))),
              Text(item.name),
              ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, "/createteam",
                      arguments: item),
                  child: Text("Load")),
              IconButton(
                onPressed: () => deleteGroup(),
                icon: Icon(Icons.cake),
              )
            ],
          ),
          tilePadding: const EdgeInsets.all(1),
          dense: true,
          children: [FormatObject(item)],
        ),
      ),
    );
  }

  Future<void> deleteGroup() async {
    var db = FirebaseFirestore.instance;
    String? account = await FirestoreService().getUserAccount();
    if (account != null) {
      String path = "accounts/$account/data/teams/history";
      var ref = db.collection(path);
      var query = ref.where("date", isEqualTo: item.date);
      query.get().then(
        (snapshot) async {
          for (var i in snapshot.docs) {
            String docPath = "accounts/$account/data/teams/history/${i.id}";
            await db.doc(docPath).delete();
          }
        },
      );
    }
  }
}
