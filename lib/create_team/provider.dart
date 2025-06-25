import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';

class CreateTeamProvider extends ChangeNotifier {
  final MainProvider provider;
  bool unsavedData = false;
  BasicLogger logger = BasicLogger();
  List<DogNote> dogNotes = [];
  List<String> runningDogIds = [];
  List<Dog> get dogs => provider.dogs;
  TeamGroup group = TeamGroup(
    teams: [
      Team(
        dogPairs: [
          DogPair(),
          DogPair(),
        ],
      ),
    ],
    date: DateTime.now(),
  );
  Map<String, Dog> get dogsById => provider.dogsById;
  CreateTeamProvider(this.provider) {
    _buildNotes();
    _buildDistanceWarnings();
  }
  void _buildDistanceWarnings() async {
    DateTime earliestGlobalDate = _buildEarliestGlobalDate();
    DateTime earliestDogDate = _buildEarliestDogDate();

    DateTime earliestWarningDate;
    if (earliestGlobalDate.isBefore(earliestDogDate)) {
      earliestWarningDate = earliestGlobalDate;
    } else {
      earliestWarningDate = earliestDogDate;
    }

    Set<TeamGroup> teamsAfterEarliestWarning =
        await _getTeamsAfterEarliestWarning(earliestWarningDate);

    // Process global warnings
    _addGlobalWarnings(teamsAfterEarliestWarning);

    // Process dog-specific warnings
    _addDogSpecificWarnings(teamsAfterEarliestWarning);

    notifyListeners();
  }

  void _addDogSpecificWarnings(Set<TeamGroup> teamGroups) {
    for (Dog dog in dogs) {
      for (DistanceWarning warning in dog.distanceWarnings) {
        _addWarningToSpecificDog(dog, warning, teamGroups);
      }
    }
  }

  void _addWarningToSpecificDog(
      Dog dog, DistanceWarning warning, Set<TeamGroup> teamGroups) {
    _checkAndAddWarning(dog, warning, teamGroups);
  }

  void _checkAndAddWarning(
      Dog dog, DistanceWarning warning, Set<TeamGroup> teamGroups) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime cutoffDate = today.subtract(Duration(days: warning.daysInterval));

    double distanceRan = _dogDistanceSinceDate(dog, cutoffDate, teamGroups);

    if (distanceRan > warning.distance) {
      dogNotes = DogNoteRepository.addNote(
          notes: dogNotes,
          dogId: dog.id,
          newNote: DogNoteMessage(
              details:
                  "${distanceRan.toStringAsFixed(0)}/${warning.distance}km ${warning.daysInterval}d",
              type: warning.distanceWarningType == DistanceWarningType.soft
                  ? DogNoteType.distanceWarning
                  : DogNoteType.distanceError));
    }
  }

  double _dogDistanceSinceDate(
      Dog dog, DateTime date, Set<TeamGroup> teamGroups) {
    double toReturn = 0;
    for (TeamGroup teamGroup in teamGroups) {
      if (teamGroup.date.isAfter(date) ||
          teamGroup.date.isAtSameMomentAs(date)) {
        bool dogFoundInGroup = false;
        for (Team team in teamGroup.teams) {
          for (DogPair pair in team.dogPairs) {
            if (pair.firstDogId == dog.id || pair.secondDogId == dog.id) {
              toReturn = toReturn + teamGroup.distance;
              dogFoundInGroup = true;
              break;
            }
          }
          if (dogFoundInGroup) break;
        }
      }
    }
    return toReturn;
  }

  void _addGlobalWarnings(Set<TeamGroup> teamGroups) {
    // Pre-calculate all dog distances for each warning period
    Map<int, Map<String, double>> distancesByPeriod = {};

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Build distance maps for each unique warning period
    Set<int> uniquePeriods = provider.settings.globalDistanceWarnings
        .map((w) => w.daysInterval)
        .toSet();

    for (int days in uniquePeriods) {
      DateTime cutoff = today.subtract(Duration(days: days));
      distancesByPeriod[days] = _buildDogDistanceMap(cutoff, teamGroups);
    }

    // Now check warnings using pre-calculated distances
    for (DistanceWarning warning in provider.settings.globalDistanceWarnings) {
      Map<String, double> distances = distancesByPeriod[warning.daysInterval]!;

      for (Dog dog in dogs) {
        double distanceRan = distances[dog.id] ?? 0;
        if (distanceRan > warning.distance) {
          dogNotes = DogNoteRepository.addNote(
              notes: dogNotes,
              dogId: dog.id,
              newNote: DogNoteMessage(
                  details:
                      "${distanceRan.toStringAsFixed(0)}/${warning.distance}km ${warning.daysInterval}d",
                  type: warning.distanceWarningType == DistanceWarningType.soft
                      ? DogNoteType.distanceWarning
                      : DogNoteType.distanceError));
        }
      }
    }
  }

  Map<String, double> _buildDogDistanceMap(
      DateTime cutoff, Set<TeamGroup> teamGroups) {
    Map<String, double> distanceMap = {};

    for (TeamGroup teamGroup in teamGroups) {
      if (teamGroup.date.isAfter(cutoff) ||
          teamGroup.date.isAtSameMomentAs(cutoff)) {
        Set<String> dogsInGroup = {};

        // Collect all unique dogs in this group
        for (Team team in teamGroup.teams) {
          for (DogPair pair in team.dogPairs) {
            if (pair.firstDogId != null && pair.firstDogId!.isNotEmpty) {
              dogsInGroup.add(pair.firstDogId!);
            }
            if (pair.secondDogId != null && pair.secondDogId!.isNotEmpty) {
              dogsInGroup.add(pair.secondDogId!);
            }
          }
        }

        // Add distance once per dog
        for (String dogId in dogsInGroup) {
          distanceMap[dogId] = (distanceMap[dogId] ?? 0) + teamGroup.distance;
        }
      }
    }

    return distanceMap;
  }

  Future<Set<TeamGroup>> _getTeamsAfterEarliestWarning(DateTime cutOff) async {
    String account = await FirestoreService().getUserAccount();
    FirebaseFirestore db = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> ref =
        db.collection("accounts/$account/data/teams/history");

    ref = ref.where("date", isGreaterThan: cutOff);
    var results = await ref.get();
    var docs = results.docs;
    List<TeamGroup> teamGroups =
        docs.map((doc) => TeamGroup.fromJson(doc.data())).toList();
    return teamGroups.toSet();
  }

  DateTime _buildEarliestDogDate() {
    int interval = 0;
    for (Dog dog in provider.dogs) {
      List<DistanceWarning> distanceWarnings = dog.distanceWarnings;
      if (distanceWarnings.isEmpty) continue;
      var newDistanceWarnings = List<DistanceWarning>.from(distanceWarnings);
      newDistanceWarnings
          .sort((a, b) => a.daysInterval.compareTo(b.daysInterval));
      if (newDistanceWarnings.last.daysInterval > interval) {
        interval = newDistanceWarnings.last.daysInterval;
      }
    }
    DateTime now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    logger.debug("Max dog interval found: $interval");
    return today.subtract(Duration(days: interval));
  }

  DateTime _buildEarliestGlobalDate() {
    if (provider.settings.globalDistanceWarnings.isEmpty) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      logger.debug("No global distance warnings: returning today");
      return today;
    }
    var globalWarnings = List.from(provider.settings.globalDistanceWarnings);

    // Now you can safely sort the new list.
    globalWarnings.sort((a, b) => a.daysInterval.compareTo(b.daysInterval));

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    logger.debug("Today: $today");

    // Check if globalWarnings is not empty before accessing 'last'
    if (globalWarnings.isEmpty) {
      // Handle the case where there are no warnings.
      // Returning today's date might be a safe default.
      return today;
    }

    int longestDaysInterval = globalWarnings.last.daysInterval;
    logger.debug("Longest days interval: $longestDaysInterval");
    return today.subtract(Duration(days: longestDaysInterval));
  }

  void addDogNote(DogNote newNote) {
    dogNotes.add(newNote);
    notifyListeners();
  }

  void _buildNotes() {
    _buildTagNotes();
  }

  void _buildTagNotes() {
    final now = DateTime.now();

    for (Dog dog in dogs) {
      for (Tag tag in dog.tags) {
        // Determine if the tag is currently active (not expired)
        bool isTagActive = (tag.expired == null || tag.expired!.isAfter(now));

        // If the tag is active AND it's flagged to prevent from running, it's a note
        if (isTagActive && tag.preventFromRun) {
          dogNotes = DogNoteRepository.addNote(
            notes: dogNotes,
            dogId: dog.id,
            newNote: DogNoteMessage(
              type: DogNoteType.tagPreventing,
              details: tag.name,
            ),
          );
        } else if (isTagActive && tag.showInTeamBuilder) {
          dogNotes = DogNoteRepository.addNote(
            notes: dogNotes,
            dogId: dog.id,
            newNote: DogNoteMessage(
              type: DogNoteType.showTagInBuilder,
              details: tag.name,
            ),
          );
        }
      }
    }
  }

  void changeGlobalName(String newName) {
    var newGroup = group.copyWith(name: newName);
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  void changeDistance(double newDistance) {
    var newGroup = group.copyWith(distance: newDistance);
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  void changeNotes(String newNotes) {
    var newGroup = group.copyWith(notes: newNotes);
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  void changeAllTeams(List<Team> newTeams) {
    var newGroup = group.copyWith(teams: newTeams);
    group = newGroup;
    changeUnsavedData(true);
    updateRunningDogs();
    notifyListeners();
  }

  void addTeam({required int teamNumber}) {
    var newTeams = List<Team>.from(group.teams);
    try {
      newTeams.insert(
        teamNumber,
        Team(
          dogPairs: [
            DogPair(),
            DogPair(),
            DogPair(),
          ],
        ),
      );
    } catch (e, s) {
      logger.error("Couldn't add team", error: e, stackTrace: s);
      rethrow;
    }
    var newGroup = group.copyWith(teams: newTeams);
    group = newGroup;
    changeUnsavedData(true);
    updateRunningDogs();
    notifyListeners();
  }

  void removeTeam({required int teamNumber}) {
    var newTeams = List<Team>.from(group.teams);
    newTeams.removeAt(teamNumber);
    var newGroup = group.copyWith(teams: newTeams);
    group = newGroup;
    changeUnsavedData(true);
    updateRunningDogs();
    notifyListeners();
  }

  /// Changes the date but leaves the time of day unchanged
  void changeDate(DateTime newDate) {
    var newGroup = group.copyWith(
        date: DateTime(newDate.year, newDate.month, newDate.day,
            group.date.hour, group.date.minute));
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  /// Changes the time of day but leaves the date unchanged
  void changeTime(TimeOfDay time) {
    var newGroup = group.copyWith(
        date: DateTime(group.date.year, group.date.month, group.date.day,
            time.hour, time.minute));
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  void changeTeamName(int teamNumber, String newName) {
    group.teams[teamNumber].name = newName;
    changeUnsavedData(true);
    notifyListeners();
  }

  void addRow({required int teamNumber}) {
    group.teams[teamNumber].dogPairs.add(DogPair());
    changeUnsavedData(true);
    notifyListeners();
  }

  void removeRow({required int teamNumber, required int rowNumber}) {
    group.teams[teamNumber].dogPairs.removeAt(rowNumber);

    updateRunningDogs();
    notifyListeners();
  }

  void changeDog(
      {required String newId,
      required int teamNumber,
      required int rowNumber,
      required int dogPosition}) {
    try {
      if (dogPosition == 0) {
        group.teams[teamNumber].dogPairs[rowNumber].firstDogId = newId;
      } else if (dogPosition == 1) {
        group.teams[teamNumber].dogPairs[rowNumber].secondDogId = newId;
      }
      updateRunningDogs();
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't change dog", error: e, stackTrace: s);
      rethrow;
    }
    changeUnsavedData(true);
  }

  void updateDuplicateDogs() {
    _clearduplicateDogsNotes();
    Map<String, int> dogCounts = {};

    try {
      // Count occurrences of each dog
      for (Team team in group.teams) {
        List<DogPair> rows = team.dogPairs;
        for (DogPair row in rows) {
          String? firstDog = row.firstDogId;
          String? secondDog = row.secondDogId;

          if (firstDog != null && firstDog.isNotEmpty) {
            dogCounts[firstDog] = (dogCounts[firstDog] ?? 0) + 1;
          }

          if (secondDog != null && secondDog.isNotEmpty) {
            dogCounts[secondDog] = (dogCounts[secondDog] ?? 0) + 1;
          }
        }
      }
    } catch (e, s) {
      logger.error("Couldn't loop for updateDuplicateDogs",
          error: e, stackTrace: s);
      rethrow;
    }

    // Add to duplicateDogs if count > 1
    try {
      dogCounts.forEach((dogId, dogCount) {
        if (dogCount > 1) {
          DogNoteRepository.addNote(
              notes: dogNotes,
              dogId: dogId,
              newNote: DogNoteMessage(type: DogNoteType.duplicate));
        }
      });
    } catch (e, s) {
      logger.error("Couldn't add to duplicate dogs", error: e, stackTrace: s);
      rethrow;
    }

    notifyListeners();
  }

  String createTeamsString() {
    String stringTeams = "${group.name}\n\n";
    stringTeams = "$stringTeams${group.notes}\n\n";
    for (Team team in group.teams) {
      stringTeams = stringTeams + stringifyTeam(team);
      stringTeams = "$stringTeams\n";
    }
    stringTeams = stringTeams.substring(0, stringTeams.length - 2);
    return stringTeams;
  }

  String stringifyTeam(Team team) {
    String streamTeam = team.name;
    String dogPairs = stringifyDogPairs(team.dogPairs);
    return "$streamTeam$dogPairs\n";
  }

  String stringifyDogPairs(List<DogPair> teamDogs) {
    String dogList = "";
    for (DogPair dogPair in teamDogs) {
      dogList =
          "$dogList\n${dogsById[dogPair.firstDogId]?.name ?? ""} - ${dogsById[dogPair.secondDogId]?.name ?? ""}";
    }
    return dogList;
  }

  /// Defines whether the create team has unsaved data.
  void changeUnsavedData(bool newCUD) {
    unsavedData = newCUD;
    notifyListeners();
  }

  /// A dog is considered "running" if its ID appears in any DogPair within any Team.
  void updateRunningDogs() {
    Set<String> runningDogs = {};

    for (Team team in group.teams) {
      for (DogPair pair in team.dogPairs) {
        // Add firstDogId if it's not null or empty
        if (pair.firstDogId != null && pair.firstDogId!.isNotEmpty) {
          runningDogs.add(pair.firstDogId!);
        }

        // Add secondDogId if it's not null or empty
        if (pair.secondDogId != null && pair.secondDogId!.isNotEmpty) {
          runningDogs.add(pair.secondDogId!);
        }
      }
    }

    runningDogIds = runningDogs.toList();
    updateDuplicateDogs();
    notifyListeners();
  }

  void _clearduplicateDogsNotes() {
    List<DogNote> newList = [];
    for (var n in dogNotes) {
      DogNoteRepository.removeNoteType(n, DogNoteType.duplicate);
      if (n.dogNoteMessage.isNotEmpty) {
        newList.add(n);
      }
    }
    dogNotes = newList;
  }

  /// Takes a list of available (filtered dogs), and add errors to all the other dogs
  /// to make them not show up in the builder.
  void addErrorToUnavailableDogs(List<Dog> availableDogs) {
    // First, clear all filteredOut error types.
    List<DogNote> newDogNotes = [];
    for (DogNote dogNote in dogNotes) {
      newDogNotes.add(
          DogNoteRepository.removeNoteType(dogNote, DogNoteType.filteredOut));
    }

    // Now get a list of all the unavailable dogs from all dogs.
    List<Dog> unavailableDogs =
        dogs.where((dog) => !availableDogs.contains(dog)).toList();

    // Add an error to the unavailable dogs.
    for (Dog dog in unavailableDogs) {
      newDogNotes = DogNoteRepository.addNote(
          notes: newDogNotes,
          dogId: dog.id,
          newNote: DogNoteMessage(type: DogNoteType.filteredOut));
    }
    dogNotes = newDogNotes;
    notifyListeners();
  }
}
