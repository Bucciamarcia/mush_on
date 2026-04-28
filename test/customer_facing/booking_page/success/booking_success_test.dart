import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_facing/booking_page/success/booking_success.dart';
import 'package:mush_on/customer_facing/booking_page/success/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';

void main() {
  group('BookingConfirmationDataPage payment states', () {
    testWidgets('paid booking shows confirmation and receipt', (tester) async {
      await tester.pumpWidget(
        _pageForStatus(
          PaymentStatus.paid,
          overrides: [
            receiptUrlProvider(
              account: 'account-1',
              bookingId: 'booking-1',
            ).overrideWith(
              (_) async => const UrlAndAmount(
                url: 'https://stripe.test/receipt',
                amount: 4200,
              ),
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('Booking confirmed!'), findsOneWidget);
      expect(find.text('Payment processing'), findsNothing);
      expect(find.text('Total: 42.0€'), findsOneWidget);
      expect(find.text('View receipt'), findsOneWidget);
    });

    testWidgets('waiting booking shows processing state without receipt', (
      tester,
    ) async {
      await tester.pumpWidget(_pageForStatus(PaymentStatus.waiting));

      expect(find.text('Payment processing'), findsOneWidget);
      expect(find.text('Your booking is not confirmed yet'), findsOneWidget);
      expect(find.text('View receipt'), findsNothing);
      expect(find.textContaining('Total:'), findsNothing);
    });

    testWidgets('refunded booking shows refunded state without receipt', (
      tester,
    ) async {
      await tester.pumpWidget(_pageForStatus(PaymentStatus.refunded));

      expect(find.text('Booking refunded'), findsOneWidget);
      expect(find.text('This payment has been refunded'), findsOneWidget);
      expect(find.text('View receipt'), findsNothing);
      expect(find.textContaining('Total:'), findsNothing);
    });

    testWidgets('unknown booking shows not confirmed state without receipt', (
      tester,
    ) async {
      await tester.pumpWidget(_pageForStatus(PaymentStatus.unknown));

      expect(find.text('Payment not confirmed'), findsOneWidget);
      expect(
        find.text('We could not confirm this payment yet'),
        findsOneWidget,
      );
      expect(find.text('View receipt'), findsNothing);
      expect(find.textContaining('Total:'), findsNothing);
    });

    testWidgets(
      'deferred payment booking shows not confirmed state without receipt',
      (tester) async {
        await tester.pumpWidget(_pageForStatus(PaymentStatus.deferredPayment));

        expect(find.text('Payment not confirmed'), findsOneWidget);
        expect(
          find.text('We could not confirm this payment yet'),
          findsOneWidget,
        );
        expect(find.text('View receipt'), findsNothing);
        expect(find.textContaining('Total:'), findsNothing);
      },
    );
  });
}

Widget _pageForStatus(
  PaymentStatus status, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      home: Scaffold(
        body: BookingConfirmationDataPage(
          account: 'account-1',
          booking: Booking(
            id: 'booking-1',
            customerGroupId: 'cg-1',
            paymentStatus: status,
          ),
          customers: const [
            Customer(
              id: 'customer-1',
              bookingId: 'booking-1',
              name: 'Ada',
              pricingId: 'adult',
            ),
          ],
          cg: CustomerGroup(
            id: 'cg-1',
            tourTypeId: 'tour-1',
            datetime: DateTime(2026, 1, 1, 10),
          ),
          pricings: const [
            TourTypePricing(
              id: 'adult',
              displayName: 'Adult',
              priceCents: 4200,
            ),
          ],
        ),
      ),
    ),
  );
}
