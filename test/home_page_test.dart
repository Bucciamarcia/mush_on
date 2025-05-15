import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/home_page/main.dart';
// You might need to import your auth service mock

void main() {
  testWidgets(
    "Home page loads with correct number of elements",
    (tester) async {
      // Wrap your widget in MaterialApp to provide context
      await tester.pumpWidget(
        MaterialApp(
          home: HomePageScreenContent(),
        ),
      );

      // Now you can add assertions to verify your elements
      // For example:
      expect(find.text("Create Team"), findsOneWidget);
      expect(find.text("Kennel"), findsOneWidget);
      expect(find.text("Teams history"), findsOneWidget);
      expect(find.text("Stats"), findsOneWidget);
      expect(find.text("Log out"), findsOneWidget);
    },
  );
}
