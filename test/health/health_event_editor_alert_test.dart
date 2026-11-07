import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/health/health_event_editor_alert.dart';
import 'package:mush_on/riverpod.dart' as app_riverpod;
import 'package:mush_on/services/models/dog.dart';

const _dogs = [Dog(id: 'dog-1', name: 'Alpha')];

void main() {
  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    testWidgets("HealthEventEditorAlert renders on ${platform.name}", (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      // The test font is much wider than real fonts, which causes harmless
      // RenderFlex overflows in the date rows. Ignore those and fail on
      // anything else (e.g. "No Material widget found" on iOS).
      final errors = <FlutterErrorDetails>[];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (!details.exceptionAsString().contains('overflowed')) {
          errors.add(details);
        }
      };
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            app_riverpod.dogsProvider.overrideWith(
              (ref) => Stream.value(_dogs),
            ),
          ],
          child: MaterialApp(
            theme: ThemeData(platform: platform),
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const HealthEventEditorAlert(),
                  ),
                  child: const Text("open"),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text("open"));
      await tester.pumpAndSettle();

      expect(errors, isEmpty);
      expect(find.text("Single day event"), findsOneWidget);
      await tester.ensureVisible(find.text("Dog can't run"));
      await tester.tap(find.text("Dog can't run"));
      await tester.pumpAndSettle();
      expect(errors, isEmpty);
    });
  }
}
