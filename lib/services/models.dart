import "package:cloud_firestore/cloud_firestore.dart";
import "package:json_annotation/json_annotation.dart";

import "firestore.dart";
part "models.g.dart";

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
class TeamGroup {
  String name;
  DateTime date;
  String notes;
  List<Team> teams;

  TeamGroup({
    this.name = "",
    required this.date,
    this.notes = "",
    this.teams = const [],
  });

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

  factory TeamGroup.fromJson(Map<String, dynamic> json) =>
      _$TeamGroupFromJson(json);
  Map<String, dynamic> toJson() => _$TeamGroupToJson(this);
}

@JsonSerializable()
class Team {
  String name;
  List<DogPair> dogPairs;

  Team({
    this.name = "",
    this.dogPairs = const [],
  });

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
