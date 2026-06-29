import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/bookings/invoice_models.dart';
import 'package:mush_on/customer_management/bookings/invoice_pdf.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  group('InvoiceDetails', () {
    test('parses invoice snapshot data used by the render page', () {
      final createdAt = DateTime(2026, 7, 1, 12, 30);
      final invoice = InvoiceDetails.fromJson({
        'id': 'booking-1',
        'bookingId': 'booking-1',
        'account': 'account-1',
        'displayInvoiceNumber': 'INV-42',
        'createdAt': Timestamp.fromDate(createdAt),
        'status': 'generated',
        'issuer': {
          'legalName': 'Kennel Oy',
          'address': 'Trail 1',
          'businessId': 'FI123',
        },
        'recipient': {
          'legalName': 'Acme GmbH',
          'address': 'Market 2',
          'businessId': 'DE123',
        },
        'booking': {'name': 'Acme booking'},
        'customerGroup': {'name': 'Morning safari'},
        'tour': {'displayName': 'Aurora tour'},
        'customers': [
          {'name': 'Ada'},
        ],
        'reverseChargeVat': true,
        'lineItems': [
          {
            'pricingId': 'adult',
            'description': 'Adult',
            'quantity': 2,
            'unitGrossCents': 10000,
            'grossCents': 20000,
            'netCents': 15936,
            'vatCents': 4064,
            'vatRate': 0.255,
          },
        ],
        'totals': {
          'currency': 'EUR',
          'grossCents': 20000,
          'netCents': 15936,
          'vatCents': 4064,
          'vatBreakdown': [
            {
              'vatRate': 0.255,
              'grossCents': 20000,
              'netCents': 15936,
              'vatCents': 4064,
            },
          ],
        },
      });

      expect(invoice.displayInvoiceNumber, 'INV-42');
      expect(invoice.createdAt, createdAt);
      expect(invoice.issuer.legalName, 'Kennel Oy');
      expect(invoice.recipient.businessId, 'DE123');
      expect(invoice.lineItems.single.description, 'Adult');
      expect(invoice.lineItems.single.quantity, 2);
      expect(invoice.totals.grossCents, 20000);
      expect(invoice.totals.vatBreakdown.single.vatRate, 0.255);
      expect(invoice.reverseChargeVat, true);
    });

    test('parses callable-safe datetime maps', () {
      final createdAt = DateTime(2026, 7, 1, 12, 30);
      final invoice = InvoiceSummary.fromJson({
        'bookingId': 'booking-1',
        'displayInvoiceNumber': 'INV-42',
        'createdAt': {
          '_millisecondsSinceEpoch': createdAt.millisecondsSinceEpoch,
        },
      });

      expect(invoice.createdAt, createdAt);
    });
  });

  group('invoice PDF export', () {
    test('uses the display invoice number as the saved PDF filename', () {
      expect(
        invoicePdfFilename(_invoice(displayInvoiceNumber: 'INV-42')),
        'INV-42',
      );
    });

    test('sanitizes characters that are unsafe in saved filenames', () {
      expect(
        invoicePdfFilename(_invoice(displayInvoiceNumber: 'INV/2026:42?*')),
        'INV-2026-42-',
      );
    });

    test(
      'falls back to invoice id when the display invoice number is empty',
      () {
        expect(
          invoicePdfFilename(
            _invoice(displayInvoiceNumber: '', id: 'booking-1'),
          ),
          'booking-1',
        );
      },
    );

    test('builds a real PDF document from invoice details', () {
      final bytes = buildInvoicePdf(_invoice(displayInvoiceNumber: 'INV-42'));

      expect(bytes.length, greaterThan(1000));
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');

      final document = PdfDocument(inputBytes: bytes);
      final text = PdfTextExtractor(document).extractText();
      document.dispose();

      expect(text, contains('INV-42'));
      expect(text, contains('Kennel Oy'));
      expect(text, contains('Acme GmbH'));
      expect(text, contains('Trail line 2'));
      expect(text, contains('Recipient city'));
      expect(text, contains('Adult'));
      expect(text, isNot(contains('Mush On!')));
    });
  });
}

InvoiceDetails _invoice({
  required String displayInvoiceNumber,
  String id = 'invoice-id',
}) {
  return InvoiceDetails(
    id: id,
    bookingId: 'booking-1',
    account: 'account-1',
    displayInvoiceNumber: displayInvoiceNumber,
    createdAt: DateTime(2026, 7, 1, 12, 30),
    status: 'generated',
    issuer: const InvoicePartyDetails(
      legalName: 'Kennel Oy',
      address: 'Trail 1\nTrail line 2',
      businessId: 'FI123',
      email: 'hello@example.com',
      url: 'example.com',
    ),
    recipient: const InvoicePartyDetails(
      legalName: 'Acme GmbH',
      address: 'Market 2\nRecipient city',
      businessId: 'DE123',
    ),
    booking: {'name': 'Acme booking', 'createdOn': DateTime(2026, 6, 30, 9)},
    customerGroup: {
      'name': 'Morning safari',
      'datetime': DateTime(2026, 7, 2, 10),
    },
    tour: const {'displayName': 'Aurora tour'},
    customers: const [
      {'name': 'Ada'},
    ],
    reverseChargeVat: true,
    lineItems: const [
      InvoiceLineItem(
        pricingId: 'adult',
        description: 'Adult',
        quantity: 2,
        unitGrossCents: 10000,
        grossCents: 20000,
        netCents: 15936,
        vatCents: 4064,
        vatRate: 0.255,
      ),
    ],
    totals: const InvoiceTotals(
      currency: 'EUR',
      grossCents: 20000,
      netCents: 15936,
      vatCents: 4064,
      vatBreakdown: [
        InvoiceVatBreakdown(
          vatRate: 0.255,
          grossCents: 20000,
          netCents: 15936,
          vatCents: 4064,
        ),
      ],
    ),
  );
}
