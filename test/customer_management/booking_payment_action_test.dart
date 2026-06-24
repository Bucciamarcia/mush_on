import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/alert_editors/logic.dart';

void main() {
  group('bookingActionFor', () {
    Booking booking(PaymentStatus status) =>
        Booking(id: 'b', customerGroupId: 'cg', paymentStatus: status);

    test('paid bookings are refundable (Stripe claws back the commission)', () {
      expect(bookingActionFor(booking(PaymentStatus.paid)), BookingAction.refund);
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
}
