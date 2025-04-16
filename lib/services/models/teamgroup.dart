import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mush_on/services/models.dart';
part 'teamgroup.g.dart';

@JsonSerializable()

/// A class representing a group of teams with associated metadata.
/// It is equivalent to a "start", meaning all the teams of a convoy of sleds.
///
/// [TeamGroup] stores information about a collection of related [Team] objects,
/// including when the group was created or modified, and any additional notes.
/// This class is serializable to/from JSON using the json_serializable package.
///
/// Example:
/// ```dart
/// final teamGroup = TeamGroup(
///   name: "Division A",
///   date: DateTime.now(),
///   distance: 10,
///   notes: "Competitive teams from the eastern region",
///   teams: [team1, team2, team3],
/// );
/// ```
class TeamGroup {
  /// The name of the entire group.
  String name;

  @JsonKey(fromJson: _dateFromTimestamp, toJson: _dateToTimestamp)

  /// The date and time of the start.
  /// Note that there can be only one [TeamGroup] for a specific time and date.
  /// If more than one [TeamGroup] starts at the same time (e.g. parallel starts),
  /// they need to be separated by 1 minute.
  DateTime date;

  /// The distance ran in km.
  /// Used for stats.
  double distance;

  String notes;

  @JsonKey(fromJson: _teamsFromJson, toJson: _teamsToJson)

  /// The list of teams in the group.
  /// Each team is represented by a [Team] object.
  List<Team> teams;

  TeamGroup({
    this.name = "",
    required this.date,
    this.distance = 0,
    this.notes = "",
    this.teams = const [],
  });

  static List<Team> _teamsFromJson(List<dynamic>? teamJsonList) {
    if (teamJsonList == null) return [];
    return teamJsonList
        .map((teamJson) => Team.fromFirestoreFormat(teamJson))
        .toList();
  }

  static List<dynamic> _teamsToJson(List<Team> teams) {
    // Implement your custom serialization for teams here
    // This would depend on your Firestore structure
    return teams.map((team) => team.toJson()).toList();
  }

  static DateTime _dateFromTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now(); // Fallback
  }

  static Timestamp _dateToTimestamp(DateTime date) {
    return Timestamp.fromDate(date);
  }

  /// Add a new team at the given position
  void addTeam(int position) {
    teams.insert(position, Team(name: "${position + 1}."));
  }

  /// Remove a team at the given index
  void removeTeam(int index) {
    if (index >= 0 && index < teams.length) {
      teams.removeAt(index);
    }
  }

  /// Find duplicate dogs
  List<String> getDuplicateDogs() {
    final dogCounts = <String, int>{};

    for (final team in teams) {
      for (final pair in team.dogPairs) {
        if (pair.firstDogId != null && pair.firstDogId!.isNotEmpty) {
          dogCounts[pair.firstDogId!] = (dogCounts[pair.firstDogId!] ?? 0) + 1;
        }
        if (pair.secondDogId != null && pair.secondDogId!.isNotEmpty) {
          dogCounts[pair.secondDogId!] =
              (dogCounts[pair.secondDogId!] ?? 0) + 1;
        }
      }
    }

    return dogCounts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toList();
  }

  factory TeamGroup.fromJson(Map<String, dynamic> json) =>
      _$TeamGroupFromJson(json);
  Map<String, dynamic> toJson() => _$TeamGroupToJson(this);
}
