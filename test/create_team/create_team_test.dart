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
    late FakeMainProvider fakeMainProvider;
    late FakeCreateTeamProvider fakeCreateTeamProvider;

    Future<void> initialBuild(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<MainProvider>.value(
                  value: fakeMainProvider),
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
      fakeMainProvider = FakeMainProvider();
      fakeCreateTeamProvider = FakeCreateTeamProvider(fakeMainProvider);
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
}
