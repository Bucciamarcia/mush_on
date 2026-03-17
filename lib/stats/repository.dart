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

      itemMap["teams"] = _normalizeTeams(itemMap["teams"]);

      return TeamGroupWorkspace.fromJson(itemMap);
    }).toList();
    return teamGroups;
  }
}

List<Map<String, dynamic>> _normalizeTeams(dynamic rawTeams) {
  if (rawTeams is List) {
    return rawTeams
        .map((team) => _normalizeTeam(Map<String, dynamic>.from(team as Map)))
        .toList();
  }

  if (rawTeams is Map) {
    final entries = rawTeams.entries
        .map((entry) => _normalizeTeam(Map<String, dynamic>.from(entry.value)))
        .toList()
      ..sort(
        (a, b) => ((a["rank"] as num?)?.toInt() ?? 0)
            .compareTo((b["rank"] as num?)?.toInt() ?? 0),
      );
    return entries;
  }

  return [];
}

Map<String, dynamic> _normalizeTeam(Map<String, dynamic> teamMap) {
  final rawDogPairs = teamMap["dogPairs"];
  if (rawDogPairs is List) {
    teamMap["dogPairs"] = rawDogPairs
        .map((dogPair) => Map<String, dynamic>.from(dogPair as Map))
        .toList();
    return teamMap;
  }

  if (rawDogPairs is Map) {
    final dogPairs = rawDogPairs.entries
        .map((entry) => Map<String, dynamic>.from(entry.value))
        .toList()
      ..sort(
        (a, b) => ((a["rank"] as num?)?.toInt() ?? 0)
            .compareTo((b["rank"] as num?)?.toInt() ?? 0),
      );
    teamMap["dogPairs"] = dogPairs;
  }

  return teamMap;
}
