import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/bookings/invoice_models.dart';

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
}
