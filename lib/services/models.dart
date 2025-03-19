import "package:cloud_firestore/cloud_firestore.dart";
import "package:json_annotation/json_annotation.dart";

import "firestore.dart";
part "models.g.dart";

@JsonSerializable()
class TeamGroup {
  String name;

  @JsonKey(fromJson: _dateFromTimestamp, toJson: _dateToTimestamp)
  DateTime date;

  String notes;
  List<Team> teams;

  TeamGroup({
    this.name = "",
    required this.date,
    this.notes = "",
    this.teams = const [],
  });

  static DateTime _dateFromTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now(); // Fallback
  }

  static Timestamp _dateToTimestamp(DateTime date) {
    return Timestamp.fromDate(date);
  }

  /// Add a new team
  void addTeam(int position) {
    teams.insert(position, Team(name: "${position + 1}."));
  }

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
        if (pair.firstName != null && pair.firstName!.isNotEmpty) {
          dogCounts[pair.firstName!] = (dogCounts[pair.firstName!] ?? 0) + 1;
        }
        if (pair.secondName != null && pair.secondName!.isNotEmpty) {
          dogCounts[pair.secondName!] = (dogCounts[pair.secondName!] ?? 0) + 1;
        }
      }
    }

    return dogCounts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toList();
  }

  factory TeamGroup.fromJson(Map<String, dynamic> json) {
    // Start by creating a TeamGroup with basic properties
    final teamGroup = TeamGroup(
      name: json['name'] as String? ?? '',
      date: _dateFromTimestamp(json['date']),
      notes: json['notes'] as String? ?? '',
    );

    // Now handle the tricky teams part
    if (json['teams'] != null) {
      final teams = <Team>[];
      for (var teamJson in (json['teams'] as List)) {
        teams.add(Team.fromFirestoreFormat(teamJson));
      }
      teamGroup.teams = teams;
    }

    return teamGroup;
  }
}

@JsonSerializable()
class Team {
  String name;
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
          firstDog: Dog(name: rowData["position_1"] as String? ?? ""),
          secondDog: Dog(name: rowData["position_2"] as String? ?? ""));

      toReturn.dogPairs.add(pair);
    }

    return toReturn;
  }

  /// Add a new empty dog pair
  void addDogPair() {
    dogPairs.add(DogPair());
  }

  /// Remove a dog pair
  void removeDogPair(int index) {
    if (index >= 0 && index < dogPairs.length) {
      dogPairs.removeAt(index);
    }
  }

  /// Update a dog
  void updateDog(int pairIndex, bool isFirst, Dog? dog) {
    if (pairIndex >= 0 && pairIndex < dogPairs.length) {
      if (isFirst) {
        dogPairs[pairIndex].firstDog = dog;
      } else {
        dogPairs[pairIndex].secondDog = dog;
      }
    }
  }

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}

@JsonSerializable()
class DogPair {
  Dog? firstDog;
  Dog? secondDog;

  DogPair({
    this.firstDog,
    this.secondDog,
  });

  /// Get dog names for display
  String? get firstName => firstDog?.name;
  String? get secondName => secondDog?.name;

  /// Check if both dogs are null (empty)
  bool get isEmpty => firstDog == null && secondDog == null;

  /// For display
  @override
  String toString() => "${firstName ?? ''} - ${secondName ?? ''}";

  factory DogPair.fromJson(Map<String, dynamic> json) =>
      _$DogPairFromJson(json);
  Map<String, dynamic> toJson() => _$DogPairToJson(this);
}

@JsonSerializable()
class Dog {
  String name;
  Map<String, bool> positions;

  Dog({
    this.name = "",
    this.positions = const {
      "lead": false,
      "swing": false,
      "team": false,
      "wheel": false,
    },
  });

  factory Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);
  Map<String, dynamic> toJson() => _$DogToJson(this);

  Future<List<Dog>> getDogs() async {
    var data = await FirestoreService().getCollection("data/kennel/dogs");
    var topics = data.map((d) => Dog.fromJson(d));
    return topics.toList();
  }

  Future<void> deleteDog() async {
    // Reference to the 'dogs' collection
    CollectionReference dogsRef =
        FirebaseFirestore.instance.collection('data/kennel/dogs');

    // Query to find the document with the matching 'name' field
    QuerySnapshot querySnapshot =
        await dogsRef.where('name', isEqualTo: name).get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming 'name' is unique, delete the first matching document
      await querySnapshot.docs.first.reference.delete();
    } else {}
  }

  Stream<List<Dog>> streamDogs() {
    return FirebaseFirestore.instance
        .collection("data/kennel/dogs")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Dog.fromJson(doc.data())).toList());
  }

  /// Returns a list of dog names from a list of Dog objects
  List<String> getDogNames(List<Dog> dogObjects) {
    return dogObjects.map((dog) => dog.name).toList();
  }
}

@JsonSerializable()
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
