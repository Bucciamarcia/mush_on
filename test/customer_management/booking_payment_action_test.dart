import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/alert_editors/logic.dart';

void main() {
  group('bookingActionFor', () {
    Booking booking(PaymentStatus status) =>
        Booking(id: 'b', customerGroupId: 'cg', paymentStatus: status);

    test('paid bookings are refundable (Stripe claws back the commission)', () {
      expect(
        bookingActionFor(booking(PaymentStatus.paid)),
        BookingAction.refund,
      );
    });

    test('deferred / off-platform / waiting / unknown are cancellable', () {
      expect(
        bookingActionFor(booking(PaymentStatus.deferredPayment)),
        BookingAction.cancel,
      );
      expect(
        bookingActionFor(booking(PaymentStatus.paidOffPlatform)),
        BookingAction.cancel,
      );
      expect(
        bookingActionFor(booking(PaymentStatus.waiting)),
        BookingAction.cancel,
      );
      expect(
        bookingActionFor(booking(PaymentStatus.unknown)),
        BookingAction.cancel,
      );
    });

    test('refunded bookings offer no further action', () {
      expect(
        bookingActionFor(booking(PaymentStatus.refunded)),
        BookingAction.none,
      );
    });
  });

  group('paidOffPlatform status semantics', () {
    test('counts as an active booking in a customer group', () {
      const bookings = [
        Booking(
          id: 'paid',
          customerGroupId: 'cg',
          paymentStatus: PaymentStatus.paid,
        ),
        Booking(
          id: 'offPlatform',
          customerGroupId: 'cg',
          paymentStatus: PaymentStatus.paidOffPlatform,
        ),
        Booking(
          id: 'waiting',
          customerGroupId: 'cg',
          paymentStatus: PaymentStatus.waiting,
        ),
      ];

      expect(bookings.active.map((b) => b.id), ['paid', 'offPlatform']);
    });

    test('occupies a seat but is not on-platform paid', () {
      expect(PaymentStatus.paidOffPlatform.occupiesSeat, true);
      expect(PaymentStatus.paidOffPlatform.isOnPlatformPaid, false);
      expect(PaymentStatus.paid.isOnPlatformPaid, true);
      expect(PaymentStatus.waiting.occupiesSeat, false);
    });
  });

  group('computed booking payment display status', () {
    final now = DateTime(2026, 6, 24, 12);

    test('expired waiting booking displays as payment cancelled', () {
      final booking = Booking(
        id: 'waiting',
        customerGroupId: 'cg',
        paymentStatus: PaymentStatus.waiting,
        expiresAt: now.subtract(const Duration(minutes: 1)),
      );

      expect(
        booking.displayPaymentStatus(now),
        BookingPaymentDisplayStatus.paymentCancelled,
      );
    });

    test('unexpired and missing-expiry waiting bookings stay waiting', () {
      final unexpired = Booking(
        id: 'unexpired',
        customerGroupId: 'cg',
        paymentStatus: PaymentStatus.waiting,
        expiresAt: now.add(const Duration(minutes: 1)),
      );
      const missingExpiry = Booking(
        id: 'missing',
        customerGroupId: 'cg',
        paymentStatus: PaymentStatus.waiting,
      );

      expect(
        unexpired.displayPaymentStatus(now),
        BookingPaymentDisplayStatus.waiting,
      );
      expect(
        missingExpiry.displayPaymentStatus(now),
        BookingPaymentDisplayStatus.waiting,
      );
    });
  });

  group('customer group deletion blockers', () {
    final now = DateTime(2026, 6, 24, 12);

    test(
      'blocks paid, off-platform, deferred, and unexpired waiting bookings',
      () {
        final blocked = [
          const Booking(
            id: 'paid',
            customerGroupId: 'cg',
            paymentStatus: PaymentStatus.paid,
          ),
          const Booking(
            id: 'offPlatform',
            customerGroupId: 'cg',
            paymentStatus: PaymentStatus.paidOffPlatform,
          ),
          const Booking(
            id: 'deferred',
            customerGroupId: 'cg',
            paymentStatus: PaymentStatus.deferredPayment,
          ),
          Booking(
            id: 'waiting',
            customerGroupId: 'cg',
            paymentStatus: PaymentStatus.waiting,
            expiresAt: now.add(const Duration(minutes: 1)),
          ),
          const Booking(
            id: 'waitingMissingExpiry',
            customerGroupId: 'cg',
            paymentStatus: PaymentStatus.waiting,
          ),
        ];

        expect(
          blocked.map((booking) => booking.blocksCustomerGroupDeletion(now)),
          everyElement(true),
        );
      },
    );

    test('allows refunded, unknown, and expired waiting bookings', () {
      final allowed = [
        const Booking(
          id: 'refunded',
          customerGroupId: 'cg',
          paymentStatus: PaymentStatus.refunded,
        ),
        const Booking(id: 'unknown', customerGroupId: 'cg'),
        Booking(
          id: 'expired',
          customerGroupId: 'cg',
          paymentStatus: PaymentStatus.waiting,
          expiresAt: now.subtract(const Duration(minutes: 1)),
        ),
      ];

      expect(
        allowed.map((booking) => booking.blocksCustomerGroupDeletion(now)),
        everyElement(false),
      );
    });
  });

  group('refundPaidBookingsOneByOne', () {
    const bookings = [
      Booking(
        id: 'paid-1',
        customerGroupId: 'cg',
        paymentStatus: PaymentStatus.paid,
      ),
      Booking(
        id: 'deferred',
        customerGroupId: 'cg',
        paymentStatus: PaymentStatus.deferredPayment,
      ),
      Booking(
        id: 'offPlatform',
        customerGroupId: 'cg',
        paymentStatus: PaymentStatus.paidOffPlatform,
      ),
      Booking(
        id: 'waiting',
        customerGroupId: 'cg',
        paymentStatus: PaymentStatus.waiting,
      ),
      Booking(
        id: 'paid-2',
        customerGroupId: 'cg',
        paymentStatus: PaymentStatus.paid,
      ),
    ];

    test('refunds only paid bookings sequentially', () async {
      final refunded = <String>[];

      final result = await refundPaidBookingsOneByOne(bookings, (
        booking,
      ) async {
        refunded.add(booking.id);
      });

      expect(refunded, ['paid-1', 'paid-2']);
      expect(result.attemptedCount, 2);
      expect(result.refundedCount, 2);
      expect(result.completed, true);
    });

    test('stops on first failed refund and reports partial success', () async {
      final refunded = <String>[];

      final result = await refundPaidBookingsOneByOne(bookings, (
        booking,
      ) async {
        if (booking.id == 'paid-2') {
          throw Exception('refund failed');
        }
        refunded.add(booking.id);
      });

      expect(refunded, ['paid-1']);
      expect(result.attemptedCount, 2);
      expect(result.refundedCount, 1);
      expect(result.failedBooking?.id, 'paid-2');
      expect(result.completed, false);
    });
  });
}
