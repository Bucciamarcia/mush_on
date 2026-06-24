import 'package:flutter/material.dart' show DateTimeRange;
import 'package:mush_on/customer_management/models.dart';

/// A single revenue-bearing record, built by joining a checkoutSession (for
/// total/commission) with its booking (status, partner, tour type, date).
class FinancialRecord {
  /// Payment/booking date.
  final DateTime date;
  final PaymentStatus status;

  /// Discounted total.
  final int totalCents;

  /// 0 unless on-platform paid.
  final int commissionCents;

  /// partnerId or null.
  final String? partner;
  final String? tourTypeId;

  const FinancialRecord({
    required this.date,
    required this.status,
    required this.totalCents,
    this.commissionCents = 0,
    this.partner,
    this.tourTypeId,
  });
}

class FinancialSummary {
  /// Sum total where status in {paid, paidOffPlatform}.
  final int grossRevenueCents;

  /// Sum commission where status == paid.
  final int commissionCents;

  /// gross - commission.
  final int netRevenueCents;

  /// Sum total where status == deferredPayment.
  final int outstandingDeferredCents;

  /// Sum total where status == refunded.
  final int refundedCents;

  /// Count where status in {paid, paidOffPlatform}.
  final int paidBookingsCount;

  /// partnerId (or "direct") -> gross.
  final Map<String, int> revenueByPartner;

  /// tourTypeId -> gross.
  final Map<String, int> revenueByTourType;

  const FinancialSummary({
    required this.grossRevenueCents,
    required this.commissionCents,
    required this.netRevenueCents,
    required this.outstandingDeferredCents,
    required this.refundedCents,
    required this.paidBookingsCount,
    required this.revenueByPartner,
    required this.revenueByTourType,
  });
}

/// Aggregates records, optionally filtered to [range] (inclusive of start,
/// exclusive of end — match the existing stats widgets).
FinancialSummary computeFinancialSummary(
  List<FinancialRecord> records, {
  DateTimeRange? range,
}) {
  bool inRange(DateTime date) {
    if (range == null) return true;
    return !date.isBefore(range.start) && date.isBefore(range.end);
  }

  var gross = 0;
  var commission = 0;
  var outstanding = 0;
  var refunded = 0;
  var paidCount = 0;
  final byPartner = <String, int>{};
  final byTourType = <String, int>{};

  for (final record in records) {
    if (!inRange(record.date)) continue;
    switch (record.status) {
      case PaymentStatus.paid:
      case PaymentStatus.paidOffPlatform:
        gross += record.totalCents;
        paidCount += 1;
        if (record.status == PaymentStatus.paid) {
          commission += record.commissionCents;
        }
        final partnerKey = record.partner ?? "direct";
        byPartner[partnerKey] = (byPartner[partnerKey] ?? 0) + record.totalCents;
        final tourTypeId = record.tourTypeId;
        if (tourTypeId != null) {
          byTourType[tourTypeId] =
              (byTourType[tourTypeId] ?? 0) + record.totalCents;
        }
        break;
      case PaymentStatus.deferredPayment:
        outstanding += record.totalCents;
        break;
      case PaymentStatus.refunded:
        refunded += record.totalCents;
        break;
      case PaymentStatus.waiting:
      case PaymentStatus.unknown:
        break;
    }
  }

  return FinancialSummary(
    grossRevenueCents: gross,
    commissionCents: commission,
    netRevenueCents: gross - commission,
    outstandingDeferredCents: outstanding,
    refundedCents: refunded,
    paidBookingsCount: paidCount,
    revenueByPartner: byPartner,
    revenueByTourType: byTourType,
  );
}
