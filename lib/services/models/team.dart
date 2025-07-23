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
    @Default([]) List<DogPair> dogPairs,
  }) = _Team;

  const Team._();

  static Team fromFirestoreFormat(Map<String, dynamic> teamJson) {
    Team toReturn = Team(name: teamJson["name"] as String);
    toReturn = toReturn.copyWith(dogPairs: []);

    // Get the dogs data and handle type safety
    Map<String, dynamic>? dogsJson = teamJson["dogs"] as Map<String, dynamic>?;
    if (dogsJson == null) return toReturn;

    // Sort the row keys to ensure correct order
    List<String> sortedKeys = dogsJson.keys.toList()
      ..sort((a, b) {
        int numA = int.parse(a.split('_')[1]);
        int numB = int.parse(b.split('_')[1]);
        return numA.compareTo(numB);
      });

    List<DogPair> toAddToToReturn = [];

    // Process each row
    for (String rowKey in sortedKeys) {
      Map<String, dynamic> rowData = dogsJson[rowKey] as Map<String, dynamic>;

      // Create a new DogPair and add it to the list
      DogPair pair = DogPair(
        firstDogId: rowData["position_1"] ?? "",
        secondDogId: rowData["position_2"] ?? "",
      );
      toAddToToReturn.add(pair);
    }
    toReturn =
        toReturn.copyWith(dogPairs: [...toReturn.dogPairs, ...toAddToToReturn]);

    return toReturn;
  }

  /// Add a new empty dog pair.
  /// Mostly used show the pair in the front end to be filled.
  void addDogPair() {
    dogPairs.add(DogPair());
  }

  /// Remove a dog pair at the given index.
  void removeDogPair(int index) {
    if (index >= 0 && index < dogPairs.length) {
      dogPairs.removeAt(index);
    }
  }

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
