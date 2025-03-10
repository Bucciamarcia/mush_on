import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/teams_history/provider.dart';
import 'package:provider/provider.dart';
import 'format_exp_card_content.dart';

class TeamsHistoryMain extends StatelessWidget {
  const TeamsHistoryMain({super.key});
  @override
  Widget build(BuildContext context) {
    TeamsHistoryProvider historyProvider =
        context.watch<TeamsHistoryProvider>();
    List groups = historyProvider.groups;
    return ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> item = groups[index];
          return TeamViewer(item: item);
        });
  }
}

class TeamViewer extends StatelessWidget {
  final Map<String, dynamic> item;
  const TeamViewer({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      margin: const EdgeInsets.all(2),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 3),
        child: ExpansionTile(
          title: Text(DateFormat("dd-MM-yy || HH:mm")
              .format((item["date"] as Timestamp).toDate())),
          tilePadding: const EdgeInsets.all(1),
          dense: true,
          children: [FormatObject(item)],
        ),
      ),
    );
  }
}
