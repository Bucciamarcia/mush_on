import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/custom_converters.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';

import 'settings/distance_warning.dart';
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
    @Default([]) List<Tag> tags,
    @Default([]) List<CustomField> customFields,
    @Default([]) List<SingleDogNote> notes,
    @Default([]) List<DistanceWarning> distanceWarnings,
    @TimestampConverter() DateTime? birth,
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

  /// The number of years of this dog
  int? get years {
    if (birth == null) return null;
    DateTime now = DateTime.now().toUtc();
    Duration duration = now.difference(birth!);
    return (duration.inDays / 365).floor();
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

extension DogListExtension on List<Dog> {
  String? getNameFromId(String id) {
    return firstWhereOrNull((dog) => dog.id == id)?.name;
  }

  Dog? getDogFromId(String id) {
    return firstWhereOrNull((dog) => dog.id == id);
  }

  /// Gets a Map with a list of dog ID -> Dog object with all dogs.
  Map<String, Dog> getAllDogsById() {
    return {for (var dog in this) dog.id: dog};
  }
}

/// All the operations related to the Dog class
class DogRepository {
  /// Gets all the tags for a list of dogs
  static List<Tag> getAllTags(List<Dog> dogs) {
    List<Tag> toReturn = [];
    for (Dog dog in dogs) {
      List<Tag> dogTags = dog.tags;
      for (Tag dogTag in dogTags) {
        if (!toReturn.contains(dogTag)) {
          toReturn.add(dogTag);
        }
      }
    }
    return toReturn;
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

  static List<String> get toList => ["Lead", "Swing", "Team", "Wheel"];
  List<String> getTrue() {
    List<String> toReturn = [];
    if (lead == true) toReturn.add("Lead");
    if (swing == true) toReturn.add("Swing");
    if (team == true) toReturn.add("Team");
    if (wheel == true) toReturn.add("Wheel");
    return toReturn;
  }
}

@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    @Default("") String id,
    @Default("") String name,
    @Default(false) bool preventFromRun,
    @Default(false) bool showInTeamBuilder,
    @TimestampConverter() required DateTime created,
    @ColorConverter() @Default(Colors.green) Color color,
    @TimestampConverter() DateTime? expired,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

extension TagListExtension on List<Tag> {
  /// Only returns the tags that are not expired.
  List<Tag> get available {
    final now = DateTime.now();
    return where((tag) => tag.expired == null || tag.expired!.isAfter(now))
        .toList();
  }
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) {
    return Color(json);
  }

  @override
  int toJson(Color object) {
    return object.toARGB32();
  }
}

/// Contains all the operations related to the tags
class TagRepository {
  /// Returns of a list of all the unique tags
  static List<Tag> getAllTagsFromDogs(List<Dog> dogs) {
    Set<String> uniqueTagNames = {};
    List<Tag> toReturn = [];

    for (Dog dog in dogs) {
      for (Tag tag in dog.tags) {
        if (uniqueTagNames.add(tag.name)) {
          toReturn.add(tag);
        }
      }
    }
    return toReturn;
  }
}
