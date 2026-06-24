import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/partners/models.dart';
import 'package:mush_on/customer_management/partners/logic.dart';

void main() {
  group('Partner model', () {
    test('round-trips through json keeping the id as a field', () {
      const partner = Partner(
        id: 'partner-1',
        name: 'Acme Tours',
        code: 'acme',
        email: 'ops@acme.example',
        discountRate: 0.1,
        allowDeferred: true,
        deferredDays: 7,
      );

      final json = partner.toJson();
      expect(json['id'], 'partner-1');
      expect(json['code'], 'acme');
      expect(json['discountRate'], 0.1);
      expect(json['allowDeferred'], true);
      expect(json['deferredDays'], 7);

      expect(Partner.fromJson(json), partner);
    });

    test('defaults: not archived, no discount, no deferral', () {
      const partner = Partner(id: 'p');
      expect(partner.archived, false);
      expect(partner.allowDeferred, false);
      expect(partner.deferredDays, 0);
      expect(partner.discountRate, isNull);
    });
  });

  group('PartnersExtension', () {
    const partners = [
      Partner(id: 'a', code: 'ALPHA'),
      Partner(id: 'b', code: 'beta', archived: true),
      Partner(id: 'c', code: 'gamma'),
    ];

    test('active excludes archived', () {
      expect(partners.active.map((p) => p.id), ['a', 'c']);
    });

    test('fromId returns the matching partner or null', () {
      expect(partners.fromId('c')?.code, 'gamma');
      expect(partners.fromId('missing'), isNull);
    });

    test('fromCode is case-insensitive and skips archived', () {
      expect(partners.fromCode('alpha')?.id, 'a');
      expect(partners.fromCode('  GAMMA ')?.id, 'c');
      // archived partner must never resolve from a code.
      expect(partners.fromCode('beta'), isNull);
    });
  });

  group('partner payment logic', () {
    test('canDeferPayment requires a partner with allowDeferred', () {
      expect(canDeferPayment(null), false);
      expect(canDeferPayment(const Partner(id: 'p')), false);
      expect(
        canDeferPayment(const Partner(id: 'p', allowDeferred: true)),
        true,
      );
    });

    test('discountedPriceCents applies and rounds the discount', () {
      const partner = Partner(id: 'p', discountRate: 0.1);
      expect(discountedPriceCents(10000, partner), 9000);
      // rounding: 9999 * 0.9 = 8999.1 -> 8999
      expect(discountedPriceCents(9999, partner), 8999);
    });

    test('discountedPriceCents is a no-op without a discount', () {
      expect(discountedPriceCents(10000, null), 10000);
      expect(discountedPriceCents(10000, const Partner(id: 'p')), 10000);
      expect(
        discountedPriceCents(10000, const Partner(id: 'p', discountRate: 0)),
        10000,
      );
    });

    test('paymentDueDate is tour date minus deferredDays', () {
      const partner = Partner(id: 'p', deferredDays: 7);
      expect(
        paymentDueDate(DateTime(2026, 7, 10), partner),
        DateTime(2026, 7, 3),
      );
    });
  });
}
