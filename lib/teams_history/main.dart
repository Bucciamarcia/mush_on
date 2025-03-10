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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat("dd-MM-yy || HH:mm")
                  .format((item["date"] as Timestamp).toDate())),
              Text(item["name"]),
              ElevatedButton(
                  onPressed: () => sendDataToTeamBuilder(context, item),
                  child: Text("Load team"))
            ],
          ),
          tilePadding: const EdgeInsets.all(1),
          dense: true,
          children: [FormatObject(item)],
        ),
      ),
    );
  }

  /// This function transforms the data from the Firestore format to the format used in the team builder.
  ///
  /// Made using GPT so BLAH, but gotta change it when using objects in future.
  void sendDataToTeamBuilder(BuildContext context, Map<String, dynamic> item) {
    // Create the new transformed item
    Map<String, dynamic> transformedItem = {};

    // Copy over the non-team fields
    transformedItem['name'] = item['name'];
    transformedItem['notes'] = item['notes'];
    transformedItem['date'] = item['date'];

    // Extract the teams list from the original map
    List<dynamic> originalTeams = item['teams'];
    List<Map<String, Object>> newTeams = [];

    // Process each team
    for (var team in originalTeams) {
      Map<String, dynamic> dogs = team['dogs'];

      // Create dogs 2D array with 3 rows and 2 columns, initially empty
      List<List<String>> dogsArray = [
        ["", ""],
        ["", ""],
        ["", ""]
      ];

      // Fill in the dogs array from the original structure
      dogs.forEach((rowKey, rowValue) {
        // Extract row index from key (e.g., "row_0" -> 0)
        int rowIndex = int.parse(rowKey.split('_')[1]);

        // Ensure we don't exceed array bounds
        if (rowIndex < dogsArray.length) {
          rowValue.forEach((posKey, dogName) {
            // Extract position index from key (e.g., "position_1" -> 0)
            // Subtract 1 because position seems to be 1-indexed but we want 0-indexed
            int posIndex = int.parse(posKey.split('_')[1]) - 1;

            // Ensure we don't exceed array bounds
            if (posIndex >= 0 && posIndex < dogsArray[rowIndex].length) {
              dogsArray[rowIndex][posIndex] = dogName;
            }
          });
        }
      });

      // Add the processed team to the new format
      newTeams.add({"name": team['name'], "dogs": dogsArray});
    }

    // Add the transformed teams to the result
    transformedItem['teams'] = newTeams;

    Navigator.pushNamed(context, "/createteam", arguments: transformedItem);
  }
}
