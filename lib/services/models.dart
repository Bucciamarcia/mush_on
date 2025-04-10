import "package:cloud_firestore/cloud_firestore.dart";
import "package:json_annotation/json_annotation.dart";
import "package:mush_on/services/error_handling.dart";

import "firestore.dart";
part "models.g.dart";

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

@JsonSerializable()

/// A class representing a pair of dogs in a team.
/// A [DogPair] consists of two [Dog] objects.
/// This class is serializable to/from JSON using the json_serializable package.
/// Example:
/// ```dart
/// final pair = DogPair(
/// firstDog: Dog(name: "Buddy"),
/// secondDog: Dog(name: "Rex"),
/// );
/// ```
class DogPair {
  String? firstDogId;
  String? secondDogId;

  DogPair({
    this.firstDogId,
    this.secondDogId,
  });

  bool get isEmpty => firstDogId == null && secondDogId == null;

  factory DogPair.fromJson(Map<String, dynamic> json) =>
      _$DogPairFromJson(json);
  Map<String, dynamic> toJson() => _$DogPairToJson(this);
}

@JsonSerializable()

/// This class represents a dog and all the info the database has about it.
class Dog {
  /// The name of  the dog.
  String name;

  /// The ID of the document for database reference.
  String id;

  /// The positions in which the dog can run in.
  DogPositions positions;

  Dog({this.name = "", this.id = "", DogPositions? positions})
      : positions = positions ?? DogPositions();

  factory Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);
  Map<String, dynamic> toJson() => _$DogToJson(this);

  Future<List<Dog>> getDogs() async {
    var data = await FirestoreService().getCollection("data/kennel/dogs");
    var topics = data.map((d) => Dog.fromJson(d));
    return topics.toList();
  }

  Future<void> deleteDog() async {
    // Reference to the 'dogs' collection
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    var dogsRef = FirebaseFirestore.instance.collection(path);
    var doc = dogsRef.doc(id);
    try {
      await doc.delete();
    } catch (e, s) {
      BasicLogger().error("Can't delete dog", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<Stream<List<Dog>>> streamDogs() async {
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    return FirebaseFirestore.instance.collection(path).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Dog.fromJson(doc.data())).toList());
  }

  /// Returns a list of dog names from a list of Dog objects
  List<String> getDogNames(List<Dog> dogObjects) {
    return dogObjects.map((dog) => dog.name).toList();
  }

  List<String> getDogIds(List<Dog> dogObjects) {
    return dogObjects.map((dog) => dog.id).toList();
  }
}

@JsonSerializable()

/// Represents the positions in which a dog can run
class DogPositions {
  final bool lead;
  final bool swing;
  final bool team;
  final bool wheel;

  DogPositions(
      {this.lead = false,
      this.swing = false,
      this.team = false,
      this.wheel = false});

  factory DogPositions.fromJson(Map<String, dynamic> json) =>
      _$DogPositionsFromJson(json);
  Map<String, dynamic> toJson() => _$DogPositionsToJson(this);
}

@JsonSerializable()

/// This class represents a user in the database.
class UserName {
  @JsonKey(name: 'last_login', fromJson: _timestampToDateTime)
  final DateTime lastLogin;

  final String? account;

  UserName({required this.lastLogin, this.account});

  // Converter for Timestamp to DateTime
  static DateTime _timestampToDateTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    throw ArgumentError('Expected Timestamp');
  }

  factory UserName.fromJson(Map<String, dynamic> json) =>
      _$UserNameFromJson(json);
  Map<String, dynamic> toJson() => _$UserNameToJson(this);
}
