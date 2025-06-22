import 'package:flutter/material.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/tasks.dart';

class FakeMainProvider extends ChangeNotifier implements MainProvider {
  List<Dog> _dogs = [];
  @override
  List<Dog> get dogs => _dogs;

  final Map<String, Dog> _dogsById = {};
  @override
  Map<String, Dog> get dogsById => _dogsById;

  String _account = "";
  @override
  String get account => _account;

  SettingsModel _settings = SettingsModel();
  @override
  SettingsModel get settings => _settings;

  TasksInMemory _tasks = TasksInMemory();
  @override
  TasksInMemory get tasks => _tasks;

  FakeMainProvider() {
    _fetchDogs();
    _fetchAccount();
    _fetchSettings();
    _fetchTasks();
  }

  @override
  Future<void> addTask(Task newTask) async {
    List<Task> newTasks = [..._tasks.tasks, newTask];
    newTasks.sort((a, b) => a.title.compareTo(b.title));
    _tasks = _tasks.copyWith(tasks: newTasks);
    notifyListeners();
  }

  @override
  Future<void> editTask(Task editedTask) async {
    List<Task> newTasks = List.from(_tasks.tasks);
    newTasks.removeWhere((t) => t.id == editedTask.id);
    newTasks.add(editedTask);
    newTasks.sort((a, b) => a.title.compareTo(b.title));
    _tasks = _tasks.copyWith(tasks: newTasks);
    notifyListeners();
  }

  void _fetchAccount() async {
    _account = "test-account";
    notifyListeners();
  }

  void _fetchSettings() async {
    // Simulate fetching settings with test data
    _settings = SettingsModel(); // You can customize this with test settings
    notifyListeners();
  }

  void _fetchTasks() async {
    // Simulate fetching tasks with test data
    _tasks = TasksInMemory(
      tasks: [],
      oldestFetched: DateTime.now().subtract(Duration(days: 30)),
      noExpirationFetched: true,
    );
    notifyListeners();
  }

  @override
  Future<void> fetchOlderTasks(DateTime date) async {
    // Simulate fetching older tasks - for testing, just return without changes
    return;
  }

  void _fetchDogs() async {
    _dogs = [
      Dog(name: "Alpha", id: "id_Alpha", positions: DogPositions(lead: true)),
      Dog(name: "Bella", id: "id_Bella", positions: DogPositions(swing: true)),
      Dog(
          name: "Charlie",
          id: "id_Charlie",
          positions: DogPositions(wheel: true)),
      Dog(name: "Daisy", id: "id_Daisy", positions: DogPositions(team: true)),
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    _fetchDogsById(_dogs);
    notifyListeners();
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }

  // Test helper methods for controlling the fake data
  void setTestDogs(List<Dog> dogs) {
    _dogs = List.from(dogs)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _fetchDogsById(_dogs);
    notifyListeners();
  }

  void setTestAccount(String account) {
    _account = account;
    notifyListeners();
  }

  void setTestSettings(SettingsModel settings) {
    _settings = settings;
    notifyListeners();
  }

  void setTestTasks(List<Task> tasks) {
    _tasks = TasksInMemory(
      tasks: List.from(tasks),
      oldestFetched: DateTime.now().subtract(Duration(days: 30)),
      noExpirationFetched: true,
    );
    notifyListeners();
  }
}

class FakeCreateTeamProvider extends ChangeNotifier
    implements CreateTeamProvider {
  @override
  bool unsavedData = false;
  @override
  BasicLogger logger = BasicLogger();
  @override
  List<Dog> dogs = [];
  @override
  List<DogNote> dogNotes = [];
  @override
  List<String> runningDogIds = [];
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
    dogNotes.add(newNote);
    notifyListeners();
  }

  void _fetchDogs() async {
    dogs = [
      Dog(name: "Alpha", id: "id_Alpha", positions: DogPositions(lead: true)),
      Dog(name: "Bella", id: "id_Bella", positions: DogPositions(swing: true)),
      Dog(
          name: "Charlie",
          id: "id_Charlie",
          positions: DogPositions(wheel: true)),
      Dog(name: "Daisy", id: "id_Daisy", positions: DogPositions(team: true)),
    ]..sort((a, b) => a.name.compareTo(b.name));
    _fetchDogsById(dogs);
    _buildNotes();
    notifyListeners();
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

  @override
  changeGlobalName(String newName) {
    var newGroup = group.copyWith(name: newName);
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeDistance(double newDistance) {
    var newGroup = group.copyWith(distance: newDistance);
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeNotes(String newNotes) {
    var newGroup = group.copyWith(notes: newNotes);
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeAllTeams(List<Team> newTeams) {
    var newGroup = group.copyWith(teams: newTeams);
    group = newGroup;
    changeUnsavedData(true);
    updateRunningDogs();
    notifyListeners();
  }

  @override
  addTeam({required int teamNumber}) {
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

  @override
  removeTeam({required int teamNumber}) {
    var newTeams = List<Team>.from(group.teams);
    newTeams.removeAt(teamNumber);
    var newGroup = group.copyWith(teams: newTeams);
    group = newGroup;
    changeUnsavedData(true);
    updateRunningDogs();
    notifyListeners();
  }

  @override
  changeDate(DateTime newDate) {
    var newGroup = group.copyWith(
        date: DateTime(newDate.year, newDate.month, newDate.day,
            group.date.hour, group.date.minute));
    group = newGroup;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeTime(TimeOfDay time) {
    var newGroup = group.copyWith(
        date: DateTime(group.date.year, group.date.month, group.date.day,
            time.hour, time.minute));
    group = newGroup;
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
    updateRunningDogs();
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
      updateRunningDogs();
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't change dog", error: e, stackTrace: s);
      rethrow;
    }
    changeUnsavedData(true);
  }

  @override
  updateDuplicateDogs() {
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
          dogNotes = DogNoteRepository.addNote(
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

  @override
  void changeUnsavedData(bool newCUD) {
    unsavedData = newCUD;
    notifyListeners();
  }

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

  @override
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

  // Test helper methods for controlling the fake data
  void setTestDogs(List<Dog> dogs) {
    this.dogs = List.from(dogs)..sort((a, b) => a.name.compareTo(b.name));
    _fetchDogsById(this.dogs);
    _buildNotes();
    notifyListeners();
  }

  void setTestTeamGroup(TeamGroup teamGroup) {
    group = teamGroup;
    updateRunningDogs();
    notifyListeners();
  }

  void clearTestData() {
    dogs.clear();
    dogNotes.clear();
    runningDogIds.clear();
    _dogsById.clear();
    group = TeamGroup(
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
    unsavedData = false;
    notifyListeners();
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
