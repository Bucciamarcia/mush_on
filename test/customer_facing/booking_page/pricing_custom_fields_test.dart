import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_facing/booking_page/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/settings/stripe/riverpod.dart';
import 'package:mush_on/settings/stripe/stripe_models.dart';

void main() {
  group('bookingAllFieldsComplete pricing-specific custom fields', () {
    const childAgeField = CustomerCustomField(
      id: 'child-age',
      type: CustomerCustomFieldType.text,
      name: 'Child age',
      description: 'Age at the time of the tour',
      isRequired: true,
    );
    const dietaryField = CustomerCustomField(
      id: 'dietary',
      type: CustomerCustomFieldType.text,
      name: 'Dietary needs',
      description: '',
      isRequired: true,
    );
    const kennelInfo = BookingManagerKennelInfo(
      name: 'Kennel',
      url: 'https://example.test',
      email: 'kennel@example.test',
      cancellationPolicy: 'No refunds',
      vatRate: 0.255,
      customerCustomFields: [dietaryField],
    );
    const completeBooking = Booking(
      id: 'booking-1',
      customerGroupId: 'cg-1',
      phone: '123',
      email: 'customer@example.com',
      streetAddress: 'Main street 1',
      zipCode: '00100',
      city: 'Helsinki',
      country: 'Finland',
    );
    const pricings = [
      TourTypePricing(id: 'adult', displayName: 'Adult'),
      TourTypePricing(
        id: 'child',
        displayName: 'Child',
        customerCustomFields: [childAgeField],
      ),
    ];

    test('blocks checkout when matching pricing required field is empty', () {
      const customers = [
        Customer(
          id: 'adult-1',
          bookingId: 'booking-1',
          pricingId: 'adult',
          customerOtherInfo: {'Dietary needs': 'None'},
        ),
        Customer(
          id: 'child-1',
          bookingId: 'booking-1',
          pricingId: 'child',
          customerOtherInfo: {'Dietary needs': 'None'},
        ),
      ];

      expect(
        bookingAllFieldsComplete(
          booking: completeBooking,
          customers: customers,
          kennelInfo: kennelInfo,
          pricings: pricings,
        ),
        isFalse,
      );
    });

    test('does not require child pricing fields from adult passengers', () {
      const customers = [
        Customer(
          id: 'adult-1',
          bookingId: 'booking-1',
          pricingId: 'adult',
          customerOtherInfo: {'Dietary needs': 'None'},
        ),
      ];

      expect(
        bookingAllFieldsComplete(
          booking: completeBooking,
          customers: customers,
          kennelInfo: kennelInfo,
          pricings: pricings,
        ),
        isTrue,
      );
    });

    test('allows checkout when matching pricing required field is filled', () {
      const customers = [
        Customer(
          id: 'child-1',
          bookingId: 'booking-1',
          pricingId: 'child',
          customerOtherInfo: {'Dietary needs': 'None', 'Child age': '8'},
        ),
      ];

      expect(
        bookingAllFieldsComplete(
          booking: completeBooking,
          customers: customers,
          kennelInfo: kennelInfo,
          pricings: pricings,
        ),
        isTrue,
      );
    });
  });
}
