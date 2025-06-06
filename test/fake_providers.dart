import 'package:flutter/material.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

class FakeDogProvider extends ChangeNotifier implements DogProvider {
  List<Dog> _dogs = [];
  @override
  List<Dog> get dogs => _dogs;
  final Map<String, Dog> _dogsById = {};
  @override
  Map<String, Dog> get dogsById => _dogsById;
  String _account = "";
  @override
  String get account => _account;

  FakeDogProvider() {
    _fetchDogs();
    _fetchAccount();
  }
  void _fetchAccount() async {
    _account = "maglelin-experience";
    notifyListeners();
  }

  void _fetchDogs() async {
    _dogs = [
      Dog(name: "Fido", id: "id_Fido", positions: DogPositions(lead: true)),
      Dog(
          name: "Fluffy",
          id: "id_Fluffy",
          positions: DogPositions(swing: true)),
      Dog(
          name: "Wheeler",
          id: "id_Wheeler",
          positions: DogPositions(wheel: true)),
    ];
    _fetchDogsById(_dogs);
    notifyListeners();
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }
}

class FakeCreateTeamProvider extends ChangeNotifier
    implements CreateTeamProvider {
  @override
  BasicLogger logger = BasicLogger();
  @override
  List<DogNote> dogNotes = []; // Changed from dogErrors to dogNotes
  @override
  List<Dog> dogs = []; // Added dogs list
  @override
  List<String> runningDogIds = []; // Added runningDogIds
  @override
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
  @override
  Map<String, Dog> get dogsById => _dogsById;

  FakeCreateTeamProvider() {
    _fetchDogs();
  }

  @override
  void addDogNote(DogNote newNote) {
    // Changed from addDogError to addDogNote
    dogNotes.add(newNote);
    notifyListeners();
  }

  void _fetchDogs() {
    // Simulating the dogs fetched from Firestore
    dogs = [
      Dog(name: "Fido", id: "id_Fido", positions: DogPositions(lead: true)),
      Dog(
          name: "Fluffy",
          sex: DogSex.none,
          id: "id_Fluffy",
          positions: DogPositions(swing: true)),
      Dog(
          name: "Wheeler",
          sex: DogSex.none,
          id: "id_Wheeler",
          positions: DogPositions(wheel: true)),
    ];
    _fetchDogsById(dogs);
    _buildNotes(); // Call _buildNotes after fetching dogs
    notifyListeners();
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }

  @override
  void _buildNotes() {
    // Simplified for testing purposes
    _buildTagNotes();
  }

  @override
  void _buildTagNotes() {
    // Simulate some tag notes if needed for testing
    // For example:
    // dogNotes = DogNoteRepository.addNote(
    //   notes: dogNotes,
    //   dogId: "id_Fido",
    //   newNote: DogNoteMessage(
    //     type: DogNoteType.tagPreventing,
    //     details: "Has a cough",
    //   ),
    // );
  }

  @override
  bool unsavedData = false;

  @override
  changeGlobalName(String newName) {
    group.name = newName;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeDistance(double newDistance) {
    group.distance = newDistance;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  updateDuplicateDogs() {
    _clearduplicateDogsNotes(); // Clear existing duplicate notes
    Map<String, int> dogCounts = {};

    try {
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

  @override
  changeNotes(String newNotes) {
    group.notes = newNotes;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeAllTeams(List<Team> newTeams) {
    group.teams = newTeams;
    changeUnsavedData(true);
    updateRunningDogs(); // Call updateRunningDogs
    notifyListeners();
  }

  @override
  addTeam({required int teamNumber}) {
    try {
      group.teams.insert(
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
    changeUnsavedData(true);
    updateRunningDogs(); // Call updateRunningDogs
    notifyListeners();
  }

  @override
  removeTeam({required int teamNumber}) {
    group.teams.removeAt(teamNumber);
    changeUnsavedData(true);
    updateRunningDogs(); // Call updateRunningDogs
    notifyListeners();
  }

  /// Changes the date but leaves the time of day unchanged
  @override
  changeDate(DateTime newDate) {
    group.date = DateTime(newDate.year, newDate.month, newDate.day,
        group.date.hour, group.date.minute);
    changeUnsavedData(true);
    notifyListeners();
  }

  /// Changes the time of day but leaves the date unchanged
  @override
  changeTime(TimeOfDay time) {
    group.date = DateTime(group.date.year, group.date.month, group.date.day,
        time.hour, time.minute);
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeTeamName(int teamNumber, String newName) {
    group.teams[teamNumber].name = newName;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  addRow({required int teamNumber}) {
    group.teams[teamNumber].dogPairs.add(DogPair());
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  removeRow({required int teamNumber, required int rowNumber}) {
    group.teams[teamNumber].dogPairs.removeAt(rowNumber);
    updateRunningDogs(); // Call updateRunningDogs
    notifyListeners();
  }

  @override
  changeDog(
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
      updateRunningDogs(); // Call updateRunningDogs
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't change dog", error: e, stackTrace: s);
      rethrow;
    }
    changeUnsavedData(true);
  }

  @override
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

  @override
  String stringifyTeam(Team team) {
    String streamTeam = team.name;
    String dogPairs = stringifyDogPairs(team.dogPairs);
    return "$streamTeam$dogPairs\n";
  }

  @override
  String stringifyDogPairs(List<DogPair> teamDogs) {
    String dogList = "";
    for (DogPair dogPair in teamDogs) {
      dogList =
          "$dogList\n${dogsById[dogPair.firstDogId]?.name ?? ""} - ${dogsById[dogPair.secondDogId]?.name ?? ""}";
    }
    return dogList;
  }

  /// Defines whether the create team has unsaved data.
  @override
  void changeUnsavedData(bool newCUD) {
    unsavedData = newCUD;
    notifyListeners();
  }

  /// A dog is considered "running" if its ID appears in any DogPair within any Team.
  @override
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
    updateDuplicateDogs(); // Ensure duplicate dogs are updated when running dogs change
    notifyListeners();
  }

  @override
  void _clearduplicateDogsNotes() {
    List<DogNote> newList = [];
    for (var n in dogNotes) {
      final updatedNote =
          DogNoteRepository.removeNoteType(n, DogNoteType.duplicate);
      if (updatedNote.dogNoteMessage.isNotEmpty) {
        newList.add(updatedNote);
      }
    }
    dogNotes = newList;
  }
}

TeamGroup loadedTeam = TeamGroup(
    date: DateTime.now(),
    name: "Test name",
    notes: "Test notes",
    distance: 10,
    teams: [
      Team(
          name: "Test team name",
          dogPairs: [DogPair(firstDogId: "id_Fido", secondDogId: "id_Wheeler")])
    ]);
