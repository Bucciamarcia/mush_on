import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/main.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';

void main() {
  group('CreateTeamMain loads correctly when loadedTem is null', () {
    late FakeDogProvider fakeDogProvider;
    late FakeCreateTeamProvider fakeCreateTeamProvider;

    Future<void> initialBuild(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<DogProvider>.value(value: fakeDogProvider),
              ChangeNotifierProvider<CreateTeamProvider>.value(
                  value: fakeCreateTeamProvider),
            ],
            child: Scaffold(
              body: CreateTeamMain(),
            ),
          ),
        ),
      );
    }

    setUp(() {
      fakeDogProvider = FakeDogProvider();
      fakeCreateTeamProvider = FakeCreateTeamProvider();
    });
    testWidgets(
      "Checks that the initial build is ok",
      (tester) async {
        await initialBuild(tester);

        expect(find.text("Date"), findsOneWidget);
        expect(find.text("Time"), findsOneWidget);
        expect(find.text("Distance"), findsOneWidget);
        expect(find.widgetWithText(TextField, "Group name"), findsOneWidget);
        expect(find.widgetWithText(TextField, "Group notes"), findsOneWidget);
        expect(find.widgetWithText(TextField, "Team name"), findsOneWidget);
        expect(find.widgetWithText(TextField, "Select a dog"), findsExactly(4));
        expect(find.text("Add new row"), findsOneWidget);
        expect(find.text("Add team"), findsOneWidget);
        expect(find.text("Remove team"), findsOneWidget);
        expect(find.text("Copy teams"), findsOneWidget);
        expect(find.text("Save Teams"), findsOneWidget);
      },
    );
    testWidgets("Adds and removes a dog", (tester) async {
      await initialBuild(tester);
      // Tap the first field to show the selection.
      final textFieldFinder = find.byKey(Key("Select Dog - 0 - 0 - 0"));
      TextField textFieldWidget = tester.widget<TextField>(textFieldFinder);
      expect(textFieldWidget.controller?.text, isEmpty);
      expect(find.text("Fido"), findsNothing);
      Finder deleteDogFinder = find.widgetWithIcon(IconButton, Icons.delete);
      expect(deleteDogFinder, findsNothing);
      await tester.tap(textFieldFinder);
      await tester.pumpAndSettle();
      final fidoOptionFinder = find.text('Fido').last;
      expect(fidoOptionFinder, findsOneWidget);

      // Tap the option to select it
      await tester.tap(fidoOptionFinder);
      await tester.pumpAndSettle();
      // Verify the TextField now displays "Fido"
      expect(textFieldWidget.controller?.text, equals('Fido'));

      // Removes Fido
      expect(deleteDogFinder, findsOneWidget);
      expect(fakeCreateTeamProvider.group.teams[0].dogPairs[0].firstDogId,
          equals("id_Fido"));
      await tester.tap(deleteDogFinder);
      await tester.pumpAndSettle();
      expect(deleteDogFinder, findsNothing);
      expect(fakeCreateTeamProvider.group.teams[0].dogPairs[0].firstDogId,
          equals(""));
    });
    testWidgets("Adds and removes row", (tester) async {
      await initialBuild(tester);
      // Adds new row
      Finder addNewRowFinder =
          find.widgetWithText(ElevatedButton, "Add new row");
      await tester.tap(addNewRowFinder);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, "Select a dog"), findsExactly(6));
      var dogPairInRow = [DogPair(), DogPair(), DogPair()];
      expect(fakeCreateTeamProvider.group.teams[0].dogPairs.length,
          equals(dogPairInRow.length));

      // Remove last row
      Finder removeLastRowFinder = find.byKey(Key("Row remover: 0 - 2"));
      await tester.tap(removeLastRowFinder);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, "Select a dog"), findsExactly(4));
    });
    testWidgets("Adds and removes a team", (tester) async {
      await initialBuild(tester);
      // Add a team
      Finder addTeamFinder = find.byKey(Key("Add team  - 0"));
      expect(addTeamFinder, findsOneWidget);
      await tester.tap(addTeamFinder);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, "Select a dog"), findsExactly(10));
      Finder addTeamFinderTotal =
          find.widgetWithText(ElevatedButton, "Add team");
      expect(addTeamFinderTotal, findsExactly(2));

      // Remove a team
      Finder removeLastTeamFinder = find.byKey(Key("Remove team - 1"));
      await tester.ensureVisible(removeLastTeamFinder);
      await tester.pumpAndSettle();
      expect(removeLastTeamFinder, findsOneWidget);
      await tester.tap(removeLastTeamFinder);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, "Select a dog"), findsExactly(4));
    });
  });

  group('CreateTeamMain loads correctly when loadedTeam is passed', () {
    late FakeDogProvider fakeDogProvider;
    late FakeCreateTeamProvider fakeCreateTeamProvider;

    Future<void> initialBuild(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<DogProvider>.value(value: fakeDogProvider),
              ChangeNotifierProvider<CreateTeamProvider>.value(
                  value: fakeCreateTeamProvider),
            ],
            child: Scaffold(
              body: CreateTeamMain(
                loadedTeam: loadedTeam,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    setUp(() {
      fakeDogProvider = FakeDogProvider();
      fakeCreateTeamProvider = FakeCreateTeamProvider();
    });
    testWidgets("Verify initial setup", (tester) async {
      await initialBuild(tester);
      Finder dateFinder = find.byKey(Key("Date text field"));
      expect(dateFinder, findsOneWidget);
      final TextField dateWidget = tester.widget(dateFinder);
      expect(dateWidget.controller!.text,
          equals(DateFormat("dd-MM-yy").format(DateTime.now())));
      Finder distanceFinder = find.widgetWithText(TextField, "Distance");
      expect(distanceFinder, findsOneWidget);
      final TextField distanceWidget = tester.widget(distanceFinder);
      expect(distanceWidget.controller!.text, equals("10.0"));
      expect(find.widgetWithText(TextField, "Group name"), findsOneWidget);
      final TextField groupNameWidget =
          tester.widget(find.widgetWithText(TextField, "Group name"));
      expect(groupNameWidget.controller!.text, equals("Test name"));
      final TextField groupNotesWidget =
          tester.widget(find.widgetWithText(TextField, "Group notes"));
      expect(groupNotesWidget.controller!.text, equals("Test notes"));
      final TextField teamNameWidget =
          tester.widget(find.widgetWithText(TextField, "Team name"));
      expect(find.widgetWithText(TextField, "Team name"), findsOneWidget);
      final String providerTeamName =
          fakeCreateTeamProvider.group.teams[0].name;
      expect(providerTeamName, equals("Test team name"));
      expect(teamNameWidget.controller!.text, equals("Test team name"));
    });
  });
}

class FakeDogProvider extends ChangeNotifier implements DogProvider {
  List<Dog> _dogs = [];
  @override
  List<Dog> get dogs => _dogs;
  final Map<String, Dog> _dogsById = {};
  @override
  Map<String, Dog> get dogsById => _dogsById;

  FakeDogProvider() {
    _fetchDogs();
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

  void _fetchDogs() async {
    List<Dog> dogs = [
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
    _fetchDogsById(dogs);
    notifyListeners();
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }

  @override
  List<String> duplicateDogs = [];
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
  changeNotes(String newNotes) {
    group.notes = newNotes;
    changeUnsavedData(true);
    notifyListeners();
  }

  @override
  changeAllTeams(List<Team> newTeams) {
    group.teams = newTeams;
    changeUnsavedData(true);
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
    notifyListeners();
  }

  @override
  removeTeam({required int teamNumber}) {
    group.teams.removeAt(teamNumber);
    changeUnsavedData(true);
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
      updateDuplicateDogs();
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't change dog", error: e, stackTrace: s);
      rethrow;
    }
    changeUnsavedData(true);
  }

  @override
  updateDuplicateDogs() {
    duplicateDogs = [];
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
          duplicateDogs.add(dogId);
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

  /// Defines whether the create team has unsaved data.
  @override
  void changeUnsavedData(bool newCUD) {
    unsavedData = newCUD;
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
          dogPairs: [DogPair(firstDogId: "Id_Fido", secondDogId: "Id_Wheeler")])
    ]);
