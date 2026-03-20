import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';

void main() {
  group('TempBookingFields', () {
    test('setInitialFields seeds state only once and does not overwrite edits',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      const initialField = BookingCustomField(
        id: 'pickup',
        type: CustomerCustomFieldType.text,
        name: 'Pickup point',
        description: 'Where the group should be picked up.',
        isRequired: true,
      );
      const replacementField = BookingCustomField(
        id: 'arrival-notes',
        type: CustomerCustomFieldType.text,
        name: 'Arrival notes',
        description: 'Anything we should know before arrival.',
        isRequired: false,
      );

      container
          .read(tempBookingFieldsProvider.notifier)
          .setInitialFields(const [initialField]);
      expect(container.read(tempBookingFieldsProvider), const [initialField]);

      container
          .read(tempBookingFieldsProvider.notifier)
          .setInitialFields(const [replacementField]);
      expect(container.read(tempBookingFieldsProvider), const [initialField]);
    });

    test('add, update and remove field mutate the draft list as expected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(tempBookingFieldsProvider.notifier).addField();

      final addedField = container.read(tempBookingFieldsProvider).single;
      expect(addedField.name, isEmpty);
      expect(addedField.description, isEmpty);
      expect(addedField.type, CustomerCustomFieldType.text);
      expect(addedField.isRequired, isFalse);

      final updatedField = addedField.copyWith(
        name: 'Pickup point',
        description: 'Hotel lobby',
        isRequired: true,
      );
      container
          .read(tempBookingFieldsProvider.notifier)
          .updateField(0, updatedField);

      expect(container.read(tempBookingFieldsProvider), [updatedField]);

      container.read(tempBookingFieldsProvider.notifier).removeField(0);
      expect(container.read(tempBookingFieldsProvider), isEmpty);
    });
  });

  group('IsBookingCustomFieldsEdited', () {
    test('tracks whether booking custom fields have unsaved changes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(isBookingCustomFieldsEditedProvider), isFalse);

      container
          .read(isBookingCustomFieldsEditedProvider.notifier)
          .setEdited(true);
      expect(container.read(isBookingCustomFieldsEditedProvider), isTrue);

      container
          .read(isBookingCustomFieldsEditedProvider.notifier)
          .setEdited(false);
      expect(container.read(isBookingCustomFieldsEditedProvider), isFalse);
    });
  });
}
