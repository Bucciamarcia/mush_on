import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';

part "dog.g.dart";
part "dog.freezed.dart";

enum DogSex { male, female, none }

@freezed

/// This class represents a dog and all the info the database has about it.
abstract class Dog with _$Dog {
  @JsonSerializable(explicitToJson: true)
  const factory Dog({
    @Default("") String name,
    @Default(DogSex.none) DogSex sex,
    @Default("") String id,
    @Default(DogPositions()) DogPositions positions,
    @Default("") String pictureUrl,
    @Default([]) List<Tag> tags,
    DateTime? birth,
  }) = _Dog;

  const Dog._();

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

  String? get age {
    if (birth == null) return null;
    DateTime now = DateTime.now().toUtc();
    if (now.isBefore(birth!)) {
      BasicLogger().error("Dog birth is in the future");
      throw Exception("Dog birth is in the future");
    }
    final difference = now.difference(birth!);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;

    if (years > 0) {
      return "$years year${years > 1 ? 's' : ''}${months > 0 ? ' $months month${months > 1 ? 's' : ''}' : ''}";
    } else {
      return "$months month${months > 1 ? 's' : ''}";
    }
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

  static Future<List<DogTotal>> getRunningDailyTotals(
      {DateTime? cutoff, required String id}) async {
    return [
      DogTotal(date: DateTime.now().toUtc(), distance: 10),
      DogTotal(
          date: DateTime.now().toUtc().subtract(Duration(days: 1)),
          distance: 20)
    ];
  }
}

class DogTotal {
  final DateTime date;
  final double distance;
  late final int _fromToday;

  int get fromtoday => _fromToday;

  DogTotal({
    required this.date,
    required this.distance,
  }) : _fromToday = _calculateFromToday(date);

  static int _calculateFromToday(DateTime date) {
    DateTime now = DateTime(DateTime.now().toUtc().year,
        DateTime.now().toUtc().month, DateTime.now().toUtc().day);
    return now.difference(date).inHours;
  }
}

@freezed

/// Represents the positions in which a dog can run
abstract class DogPositions with _$DogPositions {
  const DogPositions._();
  const factory DogPositions({
    @Default(false) bool lead,
    @Default(false) bool swing,
    @Default(false) bool team,
    @Default(false) bool wheel,
  }) = _DogPositions;

  factory DogPositions.fromJson(Map<String, dynamic> json) =>
      _$DogPositionsFromJson(json);

  List<String> get toList => ["Lead", "Swing", "Team", "Wheel"];
}

@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    @Default("") String id,
    @Default("") String name,
    required DateTime created,
    @ColorConverter() @Default(Colors.green) Color color,
    DateTime? expired,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) {
    return Color(json);
  }

  @override
  int toJson(Color object) {
    return object.value;
  }
}
