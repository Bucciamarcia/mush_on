import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/alert_editors/booking.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';

void main() {
  group('BookingEditorAlert payment status', () {
    test('new manual bookings default to deferred payment', () {
      expect(
        initialManualBookingPaymentStatus(null),
        PaymentStatus.deferredPayment,
      );
    });

    test('unknown bookings are saved with the selected manual status', () {
      const booking = Booking(id: 'booking-1', customerGroupId: 'cg-1');

      expect(
        savedPaymentStatusForBooking(
          booking: booking,
          selectedManualPaymentStatus: PaymentStatus.deferredPayment,
        ),
        PaymentStatus.deferredPayment,
      );
      expect(
        savedPaymentStatusForBooking(
          booking: booking,
          selectedManualPaymentStatus: PaymentStatus.paid,
        ),
        PaymentStatus.paid,
      );
    });

    test('existing known payment statuses are preserved', () {
      const paidBooking = Booking(
        id: 'booking-1',
        customerGroupId: 'cg-1',
        paymentStatus: PaymentStatus.paid,
      );
      const waitingBooking = Booking(
        id: 'booking-2',
        customerGroupId: 'cg-1',
        paymentStatus: PaymentStatus.waiting,
      );

      expect(
        savedPaymentStatusForBooking(
          booking: paidBooking,
          selectedManualPaymentStatus: PaymentStatus.deferredPayment,
        ),
        PaymentStatus.paid,
      );
      expect(
        savedPaymentStatusForBooking(
          booking: waitingBooking,
          selectedManualPaymentStatus: PaymentStatus.paid,
        ),
        PaymentStatus.waiting,
      );
    });
  });

  group('BookingsExtension active', () {
    test('visible customer group bookings are active by default', () {
      const bookings = [
        Booking(
          id: 'paid',
          customerGroupId: 'cg-1',
          paymentStatus: PaymentStatus.paid,
        ),
        Booking(
          id: 'deferred',
          customerGroupId: 'cg-1',
          paymentStatus: PaymentStatus.deferredPayment,
        ),
        Booking(id: 'unknown', customerGroupId: 'cg-1'),
        Booking(
          id: 'waiting',
          customerGroupId: 'cg-1',
          paymentStatus: PaymentStatus.waiting,
        ),
      ];

      expect(visibleBookingsForCustomerGroup(bookings).map((b) => b.id), [
        'paid',
        'deferred',
      ]);
    });

    test('visible customer group bookings can include inactive records', () {
      const bookings = [
        Booking(
          id: 'paid',
          customerGroupId: 'cg-1',
          paymentStatus: PaymentStatus.paid,
        ),
        Booking(id: 'unknown', customerGroupId: 'cg-1'),
      ];

      expect(
        visibleBookingsForCustomerGroup(
          bookings,
          includeInactive: true,
        ).map((b) => b.id),
        ['paid', 'unknown'],
      );
    });
  });
}
