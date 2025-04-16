import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';

part "dog.g.dart";
part "dog.freezed.dart";

@freezed

/// This class represents a dog and all the info the database has about it.
abstract class Dog with _$Dog {
  const factory Dog({
    @Default("") String name,
    @Default("") String id,
    @Default(DogPositions())
    DogPositions positions, // Assuming DogPositions() is a valid default
  }) = _Dog; // This maps to the concrete class _Dog

  factory Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);

  static List<String> getDogIds(List<Dog> dogObjects) {
    return dogObjects.map((dog) => dog.id).toList();
  }

  static Map<String, Dog> dogsById(List<Dog> dogs) {
    Map<String, Dog> toReturn = {};

    for (Dog dog in dogs) {
      toReturn.addAll({dog.id: dog});
    }
    return toReturn;
  }

  /// Returns a list of dog names from a list of Dog objects
  static List<String> getDogNames(List<Dog> dogObjects) {
    return dogObjects.map((dog) => dog.name).toList();
  }
}

class DogRepository {
  Future<List<Dog>> getDogs() async {
    var data = await FirestoreService().getCollection("data/kennel/dogs");
    var topics = data.map((d) => Dog.fromJson(d));
    return topics.toList();
  }

  Future<void> deleteDog(String dogId) async {
    // Reference to the 'dogs' collection
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    var dogsRef = FirebaseFirestore.instance.collection(path);
    var doc = dogsRef.doc(dogId);
    try {
      await doc.delete();
    } catch (e, s) {
      BasicLogger().error("Can't delete dog", error: e, stackTrace: s);
      throw Exception("Can't delete dog in deleteDog()");
    }
  }

  Future<Stream<List<Dog>>> streamDogs() async {
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    return FirebaseFirestore.instance.collection(path).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Dog.fromJson(doc.data())).toList());
  }
}

@freezed

/// Represents the positions in which a dog can run
abstract class DogPositions with _$DogPositions {
  const factory DogPositions({
    @Default(false) bool lead,
    @Default(false) bool swing,
    @Default(false) bool team,
    @Default(false) bool wheel,
  }) = _DogPositions;

  factory DogPositions.fromJson(Map<String, dynamic> json) =>
      _$DogPositionsFromJson(json);
}
