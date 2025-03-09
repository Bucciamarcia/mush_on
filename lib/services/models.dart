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
    try {
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
    } catch (e) {
      print('Error deleting dog: $e');
    }
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
