import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/team_builder/select_datetime.dart';

void main() {
  final date = DateTime(2026, 1, 2, 10, 30);

  Future<void> pumpPicker(
    WidgetTester tester, {
    double distance = 0,
    void Function(double)? onDistanceChanged,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: DateTimeDistancePicker(
              teamGroup: TeamGroupWorkspace(date: date, distance: distance),
              isReadOnly: false,
              onDateChanged: (_) {},
              onDistanceChanged: onDistanceChanged ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  TextField distanceField(WidgetTester tester) =>
      tester.widget<TextField>(find.widgetWithText(TextField, 'Distance'));

  testWidgets('shows date and time of the team group', (tester) async {
    await pumpPicker(tester);
    expect(find.text('02-01-2026'), findsOneWidget);
    expect(find.text('10:30'), findsOneWidget);
  });

  testWidgets('distance field is empty when distance is 0', (tester) async {
    await pumpPicker(tester);
    expect(distanceField(tester).controller!.text, '');
  });

  testWidgets('typing a distance calls onDistanceChanged', (tester) async {
    double? changed;
    await pumpPicker(tester, onDistanceChanged: (v) => changed = v);
    await tester.enterText(find.widgetWithText(TextField, 'Distance'), '7.5');
    expect(changed, 7.5);
  });

  testWidgets('shows the loaded decimal distance', (tester) async {
    await pumpPicker(tester, distance: 12.5);
    expect(distanceField(tester).controller!.text, '12.5');
  });

  testWidgets('shows the loaded whole distance without decimals', (
    tester,
  ) async {
    await pumpPicker(tester, distance: 12);
    expect(distanceField(tester).controller!.text, '12');
  });
}
