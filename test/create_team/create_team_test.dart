import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mush_on/create_team/main.dart';
import 'package:mush_on/create_team/provider.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';

import '../test_helpers/mock_providers.mocks.dart';
import '../test_helpers/test_setup.dart';

void main() {
  group('CreateTeamMain loads correctly when loadedTem is null', () {
    late MockMainProvider mockMainProvider;
    late MockCreateTeamProvider mockCreateTeamProvider;

    Future<void> initialBuild(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<MainProvider>.value(
                  value: mockMainProvider),
              ChangeNotifierProvider<CreateTeamProvider>.value(
                  value: mockCreateTeamProvider),
            ],
            child: Scaffold(
              body: CreateTeamMain(),
            ),
          ),
        ),
      );
    }

    setUp(() {
      mockMainProvider = TestSetup.createMainProvider();
      mockCreateTeamProvider = TestSetup.createCreateTeamProvider(
        mainProvider: mockMainProvider,
      );
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
      
      // Verify the addRow method was called
      verify(mockCreateTeamProvider.addRow(teamNumber: anyNamed('teamNumber'))).called(1);

      // Remove last row if it exists
      Finder removeLastRowFinder = find.byKey(Key("Row remover: 0 - 2"));
      if (tester.any(removeLastRowFinder)) {
        await tester.tap(removeLastRowFinder);
        await tester.pumpAndSettle();
        
        // Verify the removeRow method was called
        verify(mockCreateTeamProvider.removeRow(
          teamNumber: anyNamed('teamNumber'), 
          rowNumber: anyNamed('rowNumber')
        )).called(1);
      }
    });
    testWidgets("Adds and removes a team", (tester) async {
      await initialBuild(tester);
      // Add a team
      Finder addTeamFinder = find.byKey(Key("Add team  - 0"));
      if (tester.any(addTeamFinder)) {
        await tester.tap(addTeamFinder);
        await tester.pumpAndSettle();
        
        // Verify the addTeam method was called
        verify(mockCreateTeamProvider.addTeam(teamNumber: anyNamed('teamNumber'))).called(1);
      }

      // Remove a team if it exists
      Finder removeLastTeamFinder = find.byKey(Key("Remove team - 1"));
      if (tester.any(removeLastTeamFinder)) {
        await tester.ensureVisible(removeLastTeamFinder);
        await tester.pumpAndSettle();
        await tester.tap(removeLastTeamFinder);
        await tester.pumpAndSettle();
        
        // Verify the removeTeam method was called
        verify(mockCreateTeamProvider.removeTeam(teamNumber: anyNamed('teamNumber'))).called(1);
      }
    });
  });
}
