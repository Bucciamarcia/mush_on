import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

class StatsRepository {
  final logger = BasicLogger();
  final String account;
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  StatsRepository({required this.account});

  Future<List<TeamGroupWorkspace>> teamGroupsWorkspaceFromDateRange(
      DateTime start, DateTime end) async {
    final result = await functions
        .httpsCallable("team_groups_workspace_from_date_range")
        .call({
      "account": account,
      "start": start.toIso8601String(),
      "end": end.toIso8601String(),
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    final teamGroups = (data['teamGroups'] as List).map((item) {
      final itemMap = Map<String, dynamic>.from(item as Map);

      // Convert HTTP date string to Timestamp
      if (itemMap["date"] is String) {
        final dateTime = HttpDate.parse(itemMap["date"]);
        itemMap["date"] = Timestamp.fromDate(dateTime);
      }

      // Cast nested teams array
      if (itemMap["teams"] is List) {
        itemMap["teams"] = (itemMap["teams"] as List).map((team) {
          final teamMap = Map<String, dynamic>.from(team as Map);

          // Cast nested dogPairs array
          if (teamMap["dogPairs"] is List) {
            teamMap["dogPairs"] = (teamMap["dogPairs"] as List)
                .map((dogPair) => Map<String, dynamic>.from(dogPair as Map))
                .toList();
          }

          return teamMap;
        }).toList();
      }

      return TeamGroupWorkspace.fromJson(itemMap);
    }).toList();
    return teamGroups;
  }
}
