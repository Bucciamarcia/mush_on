import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

import '../services/firestore.dart';

class CreateTeamProvider extends ChangeNotifier {
  bool unsavedData = false;
  BasicLogger logger = BasicLogger();
  List<Dog> dogs = [];
  List<DogNote> dogNotes = [];
  List<String> runningDogIds = [];
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
  final Map<String, Dog> _dogsById = {};
  Map<String, Dog> get dogsById => _dogsById;

  CreateTeamProvider() {
    _fetchDogs();
  }

  void addDogNote(DogNote newNote) {
    dogNotes.add(newNote);
    notifyListeners();
  }

  void _fetchDogs() async {
    String account = await FirestoreService().getUserAccount();
    FirebaseFirestore.instance
        .collection("accounts/$account/data/kennel/dogs")
        .snapshots()
        .listen((snapshot) {
      dogs = snapshot.docs.map((doc) => Dog.fromJson(doc.data())).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      _fetchDogsById(dogs);
      _buildNotes();
      notifyListeners();
    });
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
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
