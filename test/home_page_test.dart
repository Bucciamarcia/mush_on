import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/home_page/main.dart';
import 'package:mush_on/provider.dart';
import 'package:provider/provider.dart';

import 'test_helpers/mock_providers.mocks.dart';
import 'test_helpers/test_setup.dart';

void main() {
  testWidgets(
    "Home page loads with correct number of elements",
    (tester) async {
      final mockMainProvider = TestSetup.createMainProvider();
      
      // Wrap your widget in MaterialApp and provide the MainProvider
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<MainProvider>.value(
            value: mockMainProvider,
            child: HomePageScreenContent(),
          ),
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
