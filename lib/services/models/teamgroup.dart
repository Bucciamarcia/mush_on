import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/custom_converters.dart';
part 'teamgroup.g.dart';
part 'teamgroup.freezed.dart';

@freezed

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
abstract class TeamGroup with _$TeamGroup {
  @JsonSerializable(explicitToJson: true)
  const factory TeamGroup({
    /// The name of the entire group.
    @Default("") String name,
    @NonNullableTimestampConverter() required DateTime date,

    /// The distance ran in km.
    /// Used for stats.
    @Default(0) double distance,
    @Default("") String notes,
    @JsonKey(fromJson: _teamsFromJson, toJson: _teamsToJson)

    /// The list of teams in the group.
    /// Each team is represented by a [Team] object.
    @Default([])
    List<Team> teams,
  }) = _TeamGroup;

  const TeamGroup._();

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
}

List<Team> _teamsFromJson(List<dynamic>? teamJsonList) {
  if (teamJsonList == null) return [];
  return teamJsonList
      .map((teamJson) => Team.fromFirestoreFormat(teamJson))
      .toList();
}

List<dynamic> _teamsToJson(List<Team> teams) {
  // Implement your custom serialization for teams here
  // This would depend on your Firestore structure
  return teams.map((team) => team.toJson()).toList();
}
