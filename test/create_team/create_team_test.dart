import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/main.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';

import '../fake_providers.dart';

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
        expect(find.widgetWithText(TextField, "Select dog"), findsExactly(4));
        expect(find.text("Add new row"), findsOneWidget);
        expect(find.text("Add team"), findsOneWidget);
        expect(find.text("Remove team"), findsOneWidget);
        expect(find.text("Copy teams"), findsOneWidget);
        expect(find.text("Save Teams"), findsOneWidget);
      },
    );
    testWidgets("Adds and removes row", (tester) async {
      await initialBuild(tester);
      // Adds new row
      Finder addNewRowFinder =
          find.widgetWithText(ElevatedButton, "Add new row");
      await tester.tap(addNewRowFinder);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, "Select dog"), findsExactly(6));
      var dogPairInRow = [DogPair(), DogPair(), DogPair()];
      expect(fakeCreateTeamProvider.group.teams[0].dogPairs.length,
          equals(dogPairInRow.length));

      // Remove last row
      Finder removeLastRowFinder = find.byKey(Key("Row remover: 0 - 2"));
      await tester.tap(removeLastRowFinder);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, "Select dog"), findsExactly(4));
    });
    testWidgets("Adds and removes a team", (tester) async {
      await initialBuild(tester);
      // Add a team
      Finder addTeamFinder = find.byKey(Key("Add team  - 0"));
      expect(addTeamFinder, findsOneWidget);
      await tester.tap(addTeamFinder);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, "Select dog"), findsExactly(10));
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
      expect(find.widgetWithText(TextField, "Select dog"), findsExactly(4));
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
      expect(find.text("Fido"), findsOneWidget);
      expect(find.text("Wheeler"), findsOneWidget);

      expect(fakeCreateTeamProvider.group.teams[0].dogPairs[0].firstDogId,
          equals("id_Fido"));
      expect(fakeCreateTeamProvider.group.teams[0].dogPairs[0].secondDogId,
          equals("id_Wheeler"));

      // Now remove wheeler
      expect(fakeCreateTeamProvider.group.teams[0].dogPairs[0].firstDogId,
          equals("id_Fido"));
      Finder chipFinder = find.byKey(Key("DogSelectedChip - id_Fido"));
      Finder deleteIconFinder = find.descendant(
        of: chipFinder,
        matching: find.byIcon(Icons.clear),
      );
      await tester.tap(deleteIconFinder);
      await tester.pumpAndSettle();
      expect(fakeCreateTeamProvider.group.teams[0].dogPairs[0].firstDogId,
          equals(""));
    });
  });
}
