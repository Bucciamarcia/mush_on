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
sealed class TeamGroup with _$TeamGroup {
  @JsonSerializable(explicitToJson: true)
  const factory TeamGroup({
    @Default("") String id,

    /// The name of the entire group.
    @Default("") String name,
    @NonNullableTimestampConverter() required DateTime date,

    /// The distance ran in km.
    /// Used for stats.
    @Default(0) double distance,
    @Default("") String notes,
  }) = _TeamGroup;

  const TeamGroup._();

  factory TeamGroup.fromJson(Map<String, dynamic> json) =>
      _$TeamGroupFromJson(json);
}
