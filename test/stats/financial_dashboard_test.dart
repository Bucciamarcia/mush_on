import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/stats/financial/logic.dart';

void main() {
  FinancialRecord record({
    required DateTime date,
    required PaymentStatus status,
    int totalCents = 10000,
    int commissionCents = 0,
    String? partner,
    String? tourTypeId,
  }) {
    return FinancialRecord(
      date: date,
      status: status,
      totalCents: totalCents,
      commissionCents: commissionCents,
      partner: partner,
      tourTypeId: tourTypeId,
    );
  }

  group('computeFinancialSummary', () {
    final records = [
      record(
        date: DateTime(2026, 6, 1),
        status: PaymentStatus.paid,
        totalCents: 10000,
        commissionCents: 350,
        partner: 'partner-1',
        tourTypeId: 'tour-a',
      ),
      record(
        date: DateTime(2026, 6, 2),
        status: PaymentStatus.paidOffPlatform,
        totalCents: 5000,
        tourTypeId: 'tour-b',
      ),
      record(
        date: DateTime(2026, 6, 3),
        status: PaymentStatus.deferredPayment,
        totalCents: 8000,
        partner: 'partner-1',
        tourTypeId: 'tour-a',
      ),
      record(
        date: DateTime(2026, 6, 4),
        status: PaymentStatus.refunded,
        totalCents: 4000,
        tourTypeId: 'tour-a',
      ),
    ];

    test('revenue counts paid + paidOffPlatform totals', () {
      final summary = computeFinancialSummary(records);
      expect(summary.grossRevenueCents, 15000); // 10000 + 5000
      expect(summary.paidBookingsCount, 2);
    });

    test('commission only accrues on on-platform paid bookings', () {
      final summary = computeFinancialSummary(records);
      expect(summary.commissionCents, 350);
      expect(summary.netRevenueCents, 14650); // 15000 - 350
    });

    test('deferred is outstanding (AR), refunded is reported separately', () {
      final summary = computeFinancialSummary(records);
      expect(summary.outstandingDeferredCents, 8000);
      expect(summary.refundedCents, 4000);
    });

    test('groups revenue by partner (direct bucket for no partner)', () {
      final summary = computeFinancialSummary(records);
      expect(summary.revenueByPartner['partner-1'], 10000);
      expect(summary.revenueByPartner['direct'], 5000);
    });

    test('groups revenue by tour type', () {
      final summary = computeFinancialSummary(records);
      expect(summary.revenueByTourType['tour-a'], 10000);
      expect(summary.revenueByTourType['tour-b'], 5000);
    });

    test('date range filters records (start inclusive, end exclusive)', () {
      final summary = computeFinancialSummary(
        records,
        range: DateTimeRange(
          start: DateTime(2026, 6, 2),
          end: DateTime(2026, 6, 3),
        ),
      );
      // only the 2026-06-02 paidOffPlatform record falls in range.
      expect(summary.grossRevenueCents, 5000);
      expect(summary.outstandingDeferredCents, 0);
    });
  });
}
