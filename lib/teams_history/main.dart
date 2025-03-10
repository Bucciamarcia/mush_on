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

      // Find the maximum row number to determine array size
      int maxRowIndex = -1;
      List<String> sortedKeys = dogs.keys.toList();
      for (var key in sortedKeys) {
        if (key.startsWith('row_')) {
          int rowIndex = int.parse(key.split('_')[1]);
          if (rowIndex > maxRowIndex) {
            maxRowIndex = rowIndex;
          }
        }
      }

      // Create dogs 2D array with the appropriate number of rows (maxRowIndex + 1) and 2 columns
      List<List<String>> dogsArray =
          List.generate(maxRowIndex + 1, (_) => ["", ""]);

      // Sort the keys to ensure we process rows in order
      sortedKeys.sort((a, b) {
        int numA = int.parse(a.split('_')[1]);
        int numB = int.parse(b.split('_')[1]);
        return numA.compareTo(numB);
      });

      // Fill in the dogs array from the original structure in order
      for (var rowKey in sortedKeys) {
        // Extract row index from key (e.g., "row_0" -> 0)
        int rowIndex = int.parse(rowKey.split('_')[1]);
        Map<String, dynamic> rowValue = dogs[rowKey];

        // Sort the position keys to ensure we process positions in order
        List<String> positionKeys = rowValue.keys.toList();
        positionKeys.sort((a, b) {
          int numA = int.parse(a.split('_')[1]);
          int numB = int.parse(b.split('_')[1]);
          return numA.compareTo(numB);
        });

        // Process each position in the row
        for (var posKey in positionKeys) {
          // Extract position index from key (e.g., "position_1" -> 0)
          // Subtract 1 because position seems to be 1-indexed but we want 0-indexed
          int posIndex = int.parse(posKey.split('_')[1]) - 1;

          // Ensure we don't exceed array bounds
          if (posIndex >= 0 && posIndex < 2) {
            // Assuming always 2 columns
            dogsArray[rowIndex][posIndex] = rowValue[posKey];
          }
        }
      }

      // Add the processed team to the new format
      newTeams.add({"name": team['name'], "dogs": dogsArray});
    }

    // Add the transformed teams to the result
    transformedItem['teams'] = newTeams;

    Navigator.pushNamed(context, "/createteam", arguments: transformedItem);
  }
}
