import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/kennel/dog/tags_widget.dart';
import 'package:mush_on/services/models/dog.dart';

Future<void> _openEditor(
  WidgetTester tester,
  TargetPlatform platform,
  void Function(Tag) onSaved,
) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(platform: platform),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => TagEditor(onTagSaved: onSaved, allTags: const []),
            ),
            child: const Text("open"),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text("open"));
  await tester.pumpAndSettle();
}

void main() {
  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    group("TagEditor on ${platform.name}", () {
      testWidgets("renders without errors", (tester) async {
        await _openEditor(tester, platform, (_) {});
        expect(tester.takeException(), isNull);
        expect(find.text("Show in builder"), findsOneWidget);
        expect(find.text("Pick a color"), findsOneWidget);
      });

      testWidgets("can open color picker and toggle show in builder", (
        tester,
      ) async {
        Tag? saved;
        await _openEditor(tester, platform, (t) => saved = t);

        await tester.tap(find.text("Pick a color"));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(MaterialPicker), findsOneWidget);

        await tester.ensureVisible(find.text("Show in builder"));
        await tester.pumpAndSettle();
        await tester.tap(find.text("Show in builder"));
        await tester.pumpAndSettle();

        await tester.tap(find.text("OK"));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(saved, isNotNull);
        expect(saved!.showInTeamBuilder, isTrue);
      });
    });
  }
}
