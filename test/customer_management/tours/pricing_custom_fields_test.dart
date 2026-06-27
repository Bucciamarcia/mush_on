import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/tours/editor/main.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';

void main() {
  group('TourTypePricing customer custom fields', () {
    test('defaults pricing-specific customer fields for legacy documents', () {
      final pricing = TourTypePricing.fromJson(const {
        'id': 'adult',
        'name': 'Adult',
        'displayName': 'Adult',
        'priceCents': 10000,
        'vatRate': 0.255,
      });

      expect(pricing.customerCustomFields, isEmpty);
    });

    test('serializes pricing-specific customer fields', () {
      const field = CustomerCustomField(
        id: 'child-age',
        type: CustomerCustomFieldType.text,
        name: 'Child age',
        description: 'Age at the time of the tour',
        isRequired: true,
      );
      const pricing = TourTypePricing(
        id: 'child',
        displayName: 'Child',
        customerCustomFields: [field],
      );

      final decoded = TourTypePricing.fromJson(pricing.toJson());

      expect(decoded.customerCustomFields, const [field]);
    });

    testWidgets('existing pricing can save custom field changes', (
      tester,
    ) async {
      TourTypePricing? saved;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PricingEditorAlert(
              pricing: const TourTypePricing(id: 'child', name: 'Child'),
              onPricingSaved: (pricing) => saved = pricing,
            ),
          ),
        ),
      );

      await tester.ensureVisible(find.text('Add field'));
      await tester.tap(find.text('Add field'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save fields'));
      await tester.pumpAndSettle();

      expect(saved, isNotNull);
      expect(saved!.id, 'child');
      expect(saved!.customerCustomFields, hasLength(1));
      expect(
        saved!.customerCustomFields.single.type,
        CustomerCustomFieldType.text,
      );
    });
  });
}
