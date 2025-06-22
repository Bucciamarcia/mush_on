import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/custom_converters.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
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
}

/// All the operations related to the Dog class
class DogRepository {
  Future<List<Dog>> getDogs() async {
    var data = await FirestoreService().getCollection("data/kennel/dogs");
    var topics = data.map((d) => Dog.fromJson(d));
    return topics.toList();
  }

  Future<Stream<List<Dog>>> streamDogs() async {
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    return FirebaseFirestore.instance.collection(path).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Dog.fromJson(doc.data())).toList());
  }

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

  /// Retrieves from the db the kms run by a dog after a cutoff date.
  /// If cutoff is not set, it defaults to 30 days.
  static Future<List<DogTotal>> getDogTotals(
      {required String id, DateTime? cutoff}) async {
    // --- Effective Cutoff Date ---
    // Determine the real start date, applying default if needed, and ensure UTC midnight
    final DateTime nowUtc = DateTime.now().toUtc();
    // Default to 30 days ago if cutoff is null
    final DateTime effectiveCutoffInput =
        cutoff ?? nowUtc.subtract(const Duration(days: 30));
    // Normalize to UTC midnight to ensure consistent date comparisons
    final DateTime effectiveCutoffDate = DateTime.utc(effectiveCutoffInput.year,
        effectiveCutoffInput.month, effectiveCutoffInput.day);

    // --- Today's Date ---
    // Normalize today's date to UTC midnight
    final DateTime todayDate =
        DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);

    // --- Initialize Map with All Dates in Range ---
    Map<DateTime, double> ranByDay = {};
    DateTime loopDate = effectiveCutoffDate; // Start from the cutoff date

    // Loop from cutoff date up to (and including) today's date
    int safetyCounter = 0;
    // Set a reasonable max loop count to prevent infinite loops if dates are weird
    const int maxDaysToInitialize = 365 * 5; // e.g., 5 years

    // Use isBefore or isAtSameMomentAs for clarity
    while (
        loopDate.isBefore(todayDate) || loopDate.isAtSameMomentAs(todayDate)) {
      // Initialize this date with 0 distance
      ranByDay[loopDate] = 0.0;

      // Move to the next day (Correctly reassign the immutable result)
      loopDate = loopDate.add(const Duration(days: 1));

      // Safety break
      safetyCounter++;
      if (safetyCounter > maxDaysToInitialize) {
        BasicLogger().error(
          "Date initialization loop exceeded limit ($maxDaysToInitialize). Check cutoff/logic.", /* add error context if available */
        );
        // Depending on requirements, you might throw, return partial data, or just break.
        break;
      }
    }

    // --- Fetch Actual Run Data ---
    late List<TeamGroup> teamGroups;
    try {
      // Fetch team groups using the *original* effective cutoff (or null if DB handles default)
      // IMPORTANT: Decide if getTeamgroups needs the precise time or just the date boundary.
      // Assuming it needs the original timestamp boundary:
      teamGroups = await DogsDbOperations().getTeamgroups(effectiveCutoffInput);
      // Or if it just needs the date:
      // teamGroups = await DogsDbOperations().getTeamgroups(effectiveCutoffDate);
    } catch (e, s) {
      BasicLogger().error("Couldn't get teamGroups in getdogTotals",
          error: e, stackTrace: s);
      rethrow;
    }

    // --- Process Run Data ---
    // This part remains largely the same, it will UPDATE the map entries
    for (TeamGroup teamGroup in teamGroups) {
      // Ensure teamGroup.date is also treated as UTC for comparison
      DateTime dateNoTime = DateTime.utc(
          teamGroup.date.year, teamGroup.date.month, teamGroup.date.day);

      // Check if this date is within our initialized range (optional but good practice)
      if (ranByDay.containsKey(dateNoTime)) {
        Map<DateTime, double> processedTg = _processTeamgroup(id, teamGroup);
        // Use the distance from processedTg (which might be 0 if dog not in it)
        double distanceInGroup = processedTg[dateNoTime] ?? 0.0;

        // Update the existing entry by adding the distance for this group
        ranByDay.update(
            dateNoTime, (existingValue) => existingValue + distanceInGroup,
            // ifAbsent is technically not needed now, but doesn't hurt
            ifAbsent: () => distanceInGroup);
      } else {
        // This teamGroup's date is outside the desired range (e.g., before cutoff after init)
        // Log potentially? Or just ignore.
        // BasicLogger().info("Skipping TeamGroup outside initialized date range: $dateNoTime");
      }
    }

    // --- Convert to List ---
    List<DogTotal> toReturn = [];
    ranByDay.forEach((DateTime date, double kmRan) {
      toReturn.add(
        DogTotal(date: date, distance: kmRan), // Use kmRan (corrected variable)
      );
    });

    // Optional: Sort the list by date if needed
    toReturn.sort((a, b) => a.date.compareTo(b.date));

    return toReturn;
  }

  // _processTeamgroup remains the same as before (assuming dog ID unique per group)
  static Map<DateTime, double> _processTeamgroup(
      String id, TeamGroup teamGroup) {
    // Ensure date extraction uses UTC here too for consistency
    DateTime day = DateTime.utc(
        teamGroup.date.year, teamGroup.date.month, teamGroup.date.day);
    double distance = 0;
    // Assuming dog ID is unique per TeamGroup, original logic is fine:
    for (Team team in teamGroup.teams) {
      for (DogPair dogPair in team.dogPairs) {
        if (dogPair.firstDogId == id || dogPair.secondDogId == id) {
          // Since dog is unique in TeamGroup, finding it means it ran the full distance
          distance = teamGroup.distance;
          // Can break loops early for minor efficiency gain once found
          return {day: distance}; // Return as soon as found
        }
      }
    }
    // If loops complete without finding the dog
    return {day: distance}; // Returns {day: 0.0}
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
