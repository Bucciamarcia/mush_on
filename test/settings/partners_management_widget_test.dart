import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/partners/models.dart';
import 'package:mush_on/customer_management/partners/partners_management_view.dart';

void main() {
  const partners = [
    Partner(id: 'a', name: 'Acme Tours', code: 'acme'),
    Partner(id: 'b', name: 'Old Partner', code: 'old', archived: true),
  ];

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('lists active partners and hides archived by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        PartnersManagementView(
          partners: partners,
          onAdd: () {},
          onEdit: (_) {},
          onArchive: (_) {},
        ),
      ),
    );

    expect(find.text('Acme Tours'), findsOneWidget);
    expect(find.text('Old Partner'), findsNothing);
  });

  testWidgets('exposes edit and archive but never a delete action', (
    tester,
  ) async {
    Partner? archived;
    await tester.pumpWidget(
      wrap(
        PartnersManagementView(
          partners: partners,
          onAdd: () {},
          onEdit: (_) {},
          onArchive: (p) => archived = p,
        ),
      ),
    );

    final archiveButton = find.byKey(const Key('archive-a'));
    expect(find.byKey(const Key('edit-a')), findsOneWidget);
    expect(archiveButton, findsOneWidget);

    // There must be no delete affordance anywhere.
    expect(find.byTooltip('Delete'), findsNothing);
    expect(find.text('Delete'), findsNothing);

    await tester.tap(archiveButton);
    expect(archived?.id, 'a');
  });

  testWidgets('add button triggers onAdd', (tester) async {
    var added = false;
    await tester.pumpWidget(
      wrap(
        PartnersManagementView(
          partners: partners,
          onAdd: () => added = true,
          onEdit: (_) {},
          onArchive: (_) {},
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('add-partner')));
    expect(added, true);
  });
}
