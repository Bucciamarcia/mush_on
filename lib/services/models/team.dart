import 'package:json_annotation/json_annotation.dart';
import 'package:mush_on/services/models.dart';
part 'team.g.dart';

@JsonSerializable()

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
class Team {
  /// The name of the team.
  /// This is normally a number and/or a descriptive name.
  /// E.G. "1. Musher" or "2. 2 adults 1 kid".
  String name;

  /// The list of dog pairs in the team.
  /// Each [DogPair] object represents a pair of dogs in the team.
  /// E.G. [DogPair(firstDog: Dog(name: "Buddy"), secondDog: Dog(name: "Rex"))]
  List<DogPair> dogPairs;

  Team({
    this.name = "",
    this.dogPairs = const [],
  });

  static Team fromFirestoreFormat(Map<String, dynamic> teamJson) {
    Team toReturn = Team(name: teamJson["name"] as String);
    toReturn.dogPairs = []; // Start with empty list

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

    // Process each row
    for (String rowKey in sortedKeys) {
      Map<String, dynamic> rowData = dogsJson[rowKey] as Map<String, dynamic>;

      // Create a new DogPair and add it to the list
      DogPair pair = DogPair(
        firstDogId: rowData["position_1"] ?? "",
        secondDogId: rowData["position_2"] ?? "",
      );

      toReturn.dogPairs.add(pair);
    }

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

  /// Update a dog in the team.
  /// The [pairIndex] is the index of the dog pair in the team.
  /// The [isFirst] flag indicates whether the first or second dog should be updated.
  /// The [dog] parameter is the new dog object to be set.
  /// If the [pairIndex] is out of bounds, this method does nothing.
  void updateDog(int pairIndex, bool isFirst, String? dog) {
    if (pairIndex >= 0 && pairIndex < dogPairs.length) {
      if (isFirst) {
        dogPairs[pairIndex].firstDogId = dog;
      } else {
        dogPairs[pairIndex].secondDogId = dog;
      }
    }
  }

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
