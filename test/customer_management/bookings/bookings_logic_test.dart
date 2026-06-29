import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/bookings/bookings_logic.dart';
import 'package:mush_on/customer_management/bookings/invoice_models.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/partners/models.dart';

void main() {
  group('booking invoice rows', () {
    final bookings = [
      Booking(
        id: 'booking-old',
        name: 'Old booking',
        customerGroupId: 'group-old',
        partner: 'partner-1',
        createdOn: DateTime(2026, 3, 1, 12),
      ),
      Booking(
        id: 'booking-new',
        name: 'New booking',
        customerGroupId: 'group-new',
        email: 'customer@example.com',
        createdOn: DateTime(2026, 3, 2, 12),
      ),
      Booking(
        id: 'booking-waiting',
        name: 'Waiting booking',
        customerGroupId: 'group-new',
        paymentStatus: PaymentStatus.waiting,
        createdOn: DateTime(2026, 3, 3, 12),
      ),
      Booking(
        id: 'booking-refunded',
        name: 'Refunded booking',
        customerGroupId: 'group-new',
        paymentStatus: PaymentStatus.refunded,
        createdOn: DateTime(2026, 3, 4, 12),
      ),
    ];
    final groups = [
      CustomerGroup(
        id: 'group-old',
        name: 'Morning safari',
        datetime: DateTime(2026, 12, 10, 9),
      ),
      CustomerGroup(
        id: 'group-new',
        name: 'Evening safari',
        datetime: DateTime(2026, 1, 10, 18),
      ),
    ];
    const partners = [Partner(id: 'partner-1', name: 'Acme Tours')];
    const invoices = [
      InvoiceSummary(
        id: 'booking-old',
        bookingId: 'booking-old',
        displayInvoiceNumber: 'INV-7',
      ),
    ];

    test('joins bookings with groups, partners and invoices newest first', () {
      final rows = buildBookingInvoiceRows(
        bookings: bookings,
        customerGroups: groups,
        partners: partners,
        invoices: invoices,
      );

      expect(rows.map((row) => row.booking.id), [
        'booking-refunded',
        'booking-new',
        'booking-old',
      ]);
      expect(rows.last.partner?.name, 'Acme Tours');
      expect(rows.last.invoice?.displayInvoiceNumber, 'INV-7');
      expect(
        rows.map((row) => row.booking.id),
        isNot(contains('booking-waiting')),
      );
    });

    test('filters by invoice state and searchable booking metadata', () {
      final rows = buildBookingInvoiceRows(
        bookings: bookings,
        customerGroups: groups,
        partners: partners,
        invoices: invoices,
      );

      expect(
        filterBookingInvoiceRows(
          rows: rows,
          query: '',
          statusFilter: InvoiceStatusFilter.missing,
        ).map((row) => row.booking.id),
        ['booking-refunded', 'booking-new'],
      );
      expect(
        filterBookingInvoiceRows(
          rows: rows,
          query: 'acme',
          statusFilter: InvoiceStatusFilter.all,
        ).map((row) => row.booking.id),
        ['booking-old'],
      );
      expect(
        filterBookingInvoiceRows(
          rows: rows,
          query: '2026-03-02',
          statusFilter: InvoiceStatusFilter.all,
        ).map((row) => row.booking.id),
        ['booking-new'],
      );
    });
  });

  group('canGenerateInvoiceForBooking', () {
    test('blocks refunded and waiting bookings', () {
      expect(
        canGenerateInvoiceForBooking(
          const Booking(
            id: 'refunded',
            customerGroupId: 'cg',
            paymentStatus: PaymentStatus.refunded,
          ),
        ),
        false,
      );
      expect(
        canGenerateInvoiceForBooking(
          const Booking(
            id: 'waiting',
            customerGroupId: 'cg',
            paymentStatus: PaymentStatus.waiting,
          ),
        ),
        false,
      );
      expect(
        canGenerateInvoiceForBooking(
          const Booking(
            id: 'paid',
            customerGroupId: 'cg',
            paymentStatus: PaymentStatus.paid,
          ),
        ),
        true,
      );
    });
  });

  group('partnerInvoiceRecipient', () {
    test('returns complete invoicing details for invoice-enabled partners', () {
      const partner = Partner(
        id: 'partner-1',
        invoiceEnabled: true,
        invoiceLegalName: 'Acme Tours GmbH',
        invoiceAddress: 'Market Street 1',
        invoiceBusinessId: 'DE123',
      );

      final recipient = partnerInvoiceRecipient(partner);

      expect(recipient?.legalName, 'Acme Tours GmbH');
      expect(recipient?.businessId, 'DE123');
    });

    test('returns null when partner invoice details are incomplete', () {
      const partner = Partner(
        id: 'partner-1',
        invoiceEnabled: true,
        invoiceLegalName: 'Acme Tours GmbH',
      );

      expect(partnerInvoiceRecipient(partner), isNull);
      expect(partnerInvoiceRecipient(null), isNull);
    });
  });

  group('invoiceEmailRecipient', () {
    test('prefers partner email over booking email', () {
      const row = BookingInvoiceRow(
        booking: Booking(
          id: 'booking-1',
          customerGroupId: 'cg-1',
          email: 'customer@example.com',
        ),
        customerGroup: null,
        partner: Partner(id: 'partner-1', email: ' partner@example.com '),
        invoice: null,
      );

      expect(invoiceEmailRecipient(row), 'partner@example.com');
    });

    test('falls back to booking email', () {
      const row = BookingInvoiceRow(
        booking: Booking(
          id: 'booking-1',
          customerGroupId: 'cg-1',
          email: ' customer@example.com ',
        ),
        customerGroup: null,
        partner: null,
        invoice: null,
      );

      expect(invoiceEmailRecipient(row), 'customer@example.com');
    });
  });
}
