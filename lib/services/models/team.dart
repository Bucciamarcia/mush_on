import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models.dart';
part 'team.g.dart';
part 'team.freezed.dart';

@freezed

/// A class representing a team of sled dogs.
/// A [Team] consists of a name and a list of [DogPair] objects.
/// Each [DogPair] object represents a pair of dogs in the team.
/// This class is serializable to/from JSON using the json_serializable package.
///
/// Example:
/// ```dart
/// final team = Team(
///  name: "Team 1",
///  dogPairs: [
///  DogPair(firstDog: Dog(name: "Buddy"), secondDog: Dog(name: "Rex")),
///  DogPair(firstDog: Dog(name: "Max"), secondDog: Dog(name: "Duke")),
///  ],
///  );
///  ```
abstract class Team with _$Team {
  const factory Team({
    @Default("") String name,
    required String id,
    @Default(0) int capacity,
    required int rank,
  }) = _Team;

  const Team._();

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
