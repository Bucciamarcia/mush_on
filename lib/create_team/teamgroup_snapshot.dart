import 'package:mush_on/create_team/riverpod.dart';

class TeamGroupSnapshotFormatException implements Exception {
  final String message;

  const TeamGroupSnapshotFormatException(this.message);

  @override
  String toString() => 'TeamGroupSnapshotFormatException: $message';
}

List<TeamWorkspace> teamsFromSnapshot(dynamic rawSnapshot) {
  if (rawSnapshot is! Map || rawSnapshot.isEmpty) {
    throw const TeamGroupSnapshotFormatException(
      'teamsSnapshot must be a non-empty map',
    );
  }

  final rankedTeams = <_Ranked<Map<String, dynamic>>>[];
  final seenTeamRanks = <int>{};

  for (final entry in rawSnapshot.entries) {
    final rawTeamId = entry.key;
    if (rawTeamId is! String || rawTeamId.isEmpty) {
      throw const TeamGroupSnapshotFormatException('team id is missing');
    }
    final teamId = rawTeamId;
    if (entry.value is! Map) {
      throw TeamGroupSnapshotFormatException('team $teamId is not a map');
    }

    final teamMap = Map<String, dynamic>.from(entry.value as Map);
    final rank = _requiredRank(teamMap['rank'], 'team $teamId');
    if (!seenTeamRanks.add(rank)) {
      throw TeamGroupSnapshotFormatException('duplicate team rank $rank');
    }

    teamMap['id'] = teamId;
    teamMap['dogPairs'] = _dogPairsFromSnapshot(teamMap['dogPairs'], teamId);
    teamMap.remove('rank');
    rankedTeams.add(_Ranked(rank, teamMap));
  }

  rankedTeams.sort((a, b) => a.rank.compareTo(b.rank));
  return rankedTeams.map((team) => TeamWorkspace.fromJson(team.value)).toList();
}

List<Map<String, dynamic>> workspaceTeamsJsonFromRaw(dynamic rawTeams) {
  if (rawTeams is List) {
    return rawTeams
        .map(
          (team) => _normalizeTeamMap(Map<String, dynamic>.from(team as Map)),
        )
        .toList();
  }

  if (rawTeams is Map) {
    return teamsFromSnapshot(rawTeams).map((team) => team.toJson()).toList();
  }

  return [];
}

List<Map<String, dynamic>> _dogPairsFromSnapshot(
  dynamic rawDogPairs,
  String teamId,
) {
  if (rawDogPairs == null) {
    return [];
  }
  if (rawDogPairs is! Map) {
    throw TeamGroupSnapshotFormatException(
      'dogPairs for team $teamId must be a map',
    );
  }

  final rankedDogPairs = <_Ranked<Map<String, dynamic>>>[];
  final seenDogPairRanks = <int>{};

  for (final entry in rawDogPairs.entries) {
    final rawDogPairId = entry.key;
    if (rawDogPairId is! String || rawDogPairId.isEmpty) {
      throw TeamGroupSnapshotFormatException(
        'dog pair id is missing in team $teamId',
      );
    }
    final dogPairId = rawDogPairId;
    if (entry.value is! Map) {
      throw TeamGroupSnapshotFormatException(
        'dog pair $dogPairId in team $teamId is not a map',
      );
    }

    final dogPairMap = Map<String, dynamic>.from(entry.value as Map);
    final rank = _requiredRank(
      dogPairMap['rank'],
      'dog pair $dogPairId in team $teamId',
    );
    if (!seenDogPairRanks.add(rank)) {
      throw TeamGroupSnapshotFormatException(
        'duplicate dog pair rank $rank in team $teamId',
      );
    }

    dogPairMap['id'] = dogPairId;
    dogPairMap.remove('rank');
    rankedDogPairs.add(_Ranked(rank, dogPairMap));
  }

  rankedDogPairs.sort((a, b) => a.rank.compareTo(b.rank));
  return rankedDogPairs.map((dogPair) => dogPair.value).toList();
}

Map<String, dynamic> _normalizeTeamMap(Map<String, dynamic> teamMap) {
  final rawDogPairs = teamMap['dogPairs'];
  if (rawDogPairs is Map) {
    teamMap['dogPairs'] = _dogPairsFromSnapshot(
      rawDogPairs,
      '${teamMap['id']}',
    );
  } else if (rawDogPairs is List) {
    teamMap['dogPairs'] = rawDogPairs
        .map((dogPair) => Map<String, dynamic>.from(dogPair as Map))
        .toList();
  }
  teamMap.remove('rank');
  return teamMap;
}

int _requiredRank(dynamic rawRank, String label) {
  if (rawRank is int) {
    return rawRank;
  }
  if (rawRank is num && rawRank == rawRank.roundToDouble()) {
    return rawRank.toInt();
  }
  throw TeamGroupSnapshotFormatException('$label has invalid rank');
}

class _Ranked<T> {
  const _Ranked(this.rank, this.value);

  final int rank;
  final T value;
}
