import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/edit_kennel/dog/name_widget.dart';
import 'package:mush_on/edit_kennel/dog/positions_widget.dart';
import 'package:mush_on/services/models.dart'; // Import your widget

void main() {
  group(
    'NameWidget Tests',
    () {
      Future<void> initialBuild(WidgetTester tester,
          {required ValueChanged<String> onNameChanged}) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NameWidget(name: "Fido", onNameChanged: onNameChanged),
            ),
          ),
        );
      }

      testWidgets("Initial build", (tester) async {
        await initialBuild(tester, onNameChanged: (_) => {});
        expect(find.text("Fido"), findsOne);
        expect(find.widgetWithIcon(IconButton, Icons.edit), findsOne);
      });

      testWidgets("Click button opens dialog", (tester) async {
        // Use a dummy callback
        await initialBuild(tester, onNameChanged: (_) => {});
        Finder finder = find.byIcon(Icons.edit); // Use find.byIcon for clarity
        await tester.tap(finder);
        await tester.pumpAndSettle(); // Wait for the dialog to appear

        expect(find.text("Change dog name"), findsOne);
        // The initial name "Fido" should appear in the TextField
        expect(
            find.text("Fido"),
            findsExactly(
                2)); // One in the original widget, one in the TextField
        expect(find.byType(TextButton),
            findsExactly(2)); // Assuming Cancel and OK buttons
        expect(find.widgetWithText(TextButton, 'Cancel'),
            findsOne); // Find specific buttons
        expect(find.widgetWithText(TextButton, 'OK'), findsOne);
      });

      // --- New Test Case: Change name and press OK ---
      testWidgets("Change name and press OK calls callback with new name",
          (tester) async {
        String? capturedName;

        await initialBuild(tester, onNameChanged: (newName) {
          capturedName = newName;
        });

        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        expect(find.text("Change dog name"), findsOne);

        // 2. Find the TextField in the dialog and enter new text
        // Assuming the TextField is the only one currently visible,
        // find.byType(TextField) should work. If not, you might need
        // a more specific finder like find.descendant.
        final nameFieldFinder = find.byType(TextField);
        expect(nameFieldFinder, findsOne);

        final String newName = "Buddy";
        await tester.enterText(nameFieldFinder, newName);

        // 3. Find the "OK" button and tap it
        final okButtonFinder =
            find.widgetWithText(TextButton, 'OK'); // Find button by text
        expect(okButtonFinder, findsOne);

        await tester.tap(okButtonFinder);
        await tester
            .pumpAndSettle(); // Wait for the dialog to dismiss and potentially trigger callback

        // Verify the dialog is gone
        expect(find.text('Change dog name'), findsNothing);

        // 4. Verify that the callback was called with the correct value
        expect(capturedName, isNotNull); // Check that the callback was called
        expect(
            capturedName, newName); // Check that the value passed was 'Buddy'
      });

      // You might also want a test for the Cancel button
      testWidgets(
          "Pressing Cancel button closes dialog and does NOT call callback",
          (tester) async {
        String?
            capturedName; // Variable to hold the value passed to the callback

        await initialBuild(tester, onNameChanged: (newName) {
          capturedName = newName; // Store the new name - this should NOT happen
        });

        // 1. Tap the edit button to open the dialog
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle(); // Wait for dialog to appear

        // Verify the dialog is open
        expect(find.text("Change dog name"), findsOne);

        // 2. Enter some text (optional, but good practice)
        final nameFieldFinder = find.byType(TextField);
        expect(nameFieldFinder, findsOne);
        await tester.enterText(nameFieldFinder, "ShouldNotBeSet");

        // 3. Find the "Cancel" button and tap it
        final cancelButtonFinder =
            find.widgetWithText(TextButton, 'Cancel'); // Find button by text
        expect(cancelButtonFinder, findsOne);

        await tester.tap(cancelButtonFinder);
        await tester.pumpAndSettle(); // Wait for the dialog to dismiss

        // Verify the dialog is gone
        expect(find.text('Change dog name'), findsNothing);

        // 4. Verify that the callback was NOT called
        expect(capturedName, isNull); // Check that the callback was NOT called

        // Verify the display text is still the original name
        expect(find.text("Fido"), findsOne);
        expect(find.text("ShouldNotBeSet"), findsNothing);
      });
    },
  );
  group('Positions widget', () {
    Future<void> initialBuild(WidgetTester tester,
        {required ValueChanged<DogPositions> newPositions}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PositionsWidget(
              positions: DogPositions(
                  lead: true, swing: false, team: false, wheel: false),
              onPositionsChanged: (DogPositions newPositions) {},
            ),
          ),
        ),
      );
    }

    testWidgets("Initial build", (tester) async {
      await initialBuild(tester, newPositions: (_) {});
      expect(find.text("Positions"), findsOne);
      expect(find.byType(Card), findsExactly(4));
      expect(find.byIcon(Icons.check), findsOne);
      expect(find.byIcon(Icons.cancel_outlined), findsExactly(3));
    });
    testWidgets("Button clicked", (tester) async {
      await initialBuild(tester, newPositions: (_) {});
      final Finder editFinder = find.byIcon(Icons.edit);
      await tester.tap(editFinder);
      await tester.pumpAndSettle();
      expect(find.text("Edit positions"), findsOne);
      expect(find.text("lead"), findsOne);
      expect(find.byType(Switch), findsExactly(4));
    });
  });
}
