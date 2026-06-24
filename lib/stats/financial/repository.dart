import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/stats/financial/logic.dart';

/// Loads the revenue-bearing records for the financial dashboard.
///
/// Commission data lives on the server-only `checkoutSessions` collection, so
/// the records are assembled by the `get_financial_records` callable rather
/// than read directly from Firestore.
class FinancialRepository {
  final String account;
  final FirebaseFunctions functions;

  FinancialRepository({required this.account, FirebaseFunctions? functions})
    : functions =
          functions ?? FirebaseFunctions.instanceFor(region: "europe-north1");

  Future<List<FinancialRecord>> fetchRecords() async {
    final result = await functions.httpsCallable("get_financial_records").call({
      "account": account,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    final rawRecords = (data["records"] as List?) ?? const [];
    return rawRecords
        .map((raw) => _recordFromJson(Map<String, dynamic>.from(raw as Map)))
        .toList();
  }
}

FinancialRecord _recordFromJson(Map<String, dynamic> json) {
  final dateString = json["date"] as String?;
  return FinancialRecord(
    // Records without a resolvable customer-group date fall back to epoch so
    // they still surface (they just never match a date-range filter).
    date: dateString != null
        ? DateTime.parse(dateString)
        : DateTime.fromMillisecondsSinceEpoch(0),
    status: _statusFromString(json["status"] as String?),
    totalCents: (json["totalCents"] as num?)?.toInt() ?? 0,
    commissionCents: (json["commissionCents"] as num?)?.toInt() ?? 0,
    partner: json["partner"] as String?,
    tourTypeId: json["tourTypeId"] as String?,
  );
}

PaymentStatus _statusFromString(String? value) {
  switch (value) {
    case "paid":
      return PaymentStatus.paid;
    case "deferredPayment":
      return PaymentStatus.deferredPayment;
    case "paidOffPlatform":
      return PaymentStatus.paidOffPlatform;
    case "refunded":
      return PaymentStatus.refunded;
    case "waiting":
      return PaymentStatus.waiting;
    default:
      return PaymentStatus.unknown;
  }
}
