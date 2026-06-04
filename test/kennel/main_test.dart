import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/kennel/main.dart';
import 'package:mush_on/riverpod.dart' as app_riverpod;
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/shared/dog_filter/main.dart';

void main() {
  group('EditKennelMain dog filter', () {
    testWidgets('shows all dogs before filtering', (tester) async {
      await tester.pumpWidget(_kennelHarness());
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);
    });

    testWidgets('shows only matching dogs after a non-empty filter result', (
      tester,
    ) async {
      await tester.pumpWidget(_kennelHarness());
      await tester.pumpAndSettle();

      await _applyDogFilter(tester, [_dogs[1]]);
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsNothing);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsNothing);
    });

    testWidgets('shows all dogs and an error after an empty filter result', (
      tester,
    ) async {
      await tester.pumpWidget(_kennelHarness());
      await tester.pumpAndSettle();

      await _applyDogFilter(tester, []);
      await tester.pump();

      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);
      expect(
        find.text('Search came up empty. Showing all dogs'),
        findsOneWidget,
      );
    });
  });
}

const _dogs = [
  Dog(id: 'dog-1', name: 'Alpha'),
  Dog(id: 'dog-2', name: 'Beta'),
  Dog(id: 'dog-3', name: 'Gamma'),
];

Widget _kennelHarness() {
  return ProviderScope(
    overrides: [
      app_riverpod.dogsProvider.overrideWith((ref) => Stream.value(_dogs)),
      app_riverpod.settingsProvider.overrideWith(
        (ref) => Stream.value(const SettingsModel()),
      ),
    ],
    child: const MaterialApp(home: Scaffold(body: EditKennelMain())),
  );
}

Future<void> _applyDogFilter(WidgetTester tester, List<Dog> dogs) async {
  await tester.tap(find.text('Filter dogs'));
  await tester.pumpAndSettle();
  tester.widget<DogFilterWidget>(find.byType(DogFilterWidget)).onResult(dogs);
}
