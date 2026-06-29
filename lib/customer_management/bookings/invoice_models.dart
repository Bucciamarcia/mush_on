import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/partners/models.dart';

class InvoiceSummary {
  final String id;
  final String bookingId;
  final String displayInvoiceNumber;
  final DateTime? createdAt;

  const InvoiceSummary({
    required this.id,
    required this.bookingId,
    required this.displayInvoiceNumber,
    this.createdAt,
  });

  factory InvoiceSummary.fromJson(Map<String, dynamic> json, {String? id}) {
    return InvoiceSummary(
      id: id ?? json['id'] as String? ?? json['bookingId'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? id ?? '',
      displayInvoiceNumber:
          json['displayInvoiceNumber'] as String? ??
          _fallbackInvoiceNumber(json),
      createdAt: _readDateTime(json['createdAt']),
    );
  }

  static String _fallbackInvoiceNumber(Map<String, dynamic> json) {
    final prefix = json['invoiceNumberPrefix'] as String? ?? '';
    final number = json['invoiceNumber'];
    if (number == null) return '';
    return '$prefix$number';
  }

  static DateTime? _readDateTime(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is Map && value['_millisecondsSinceEpoch'] is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        (value['_millisecondsSinceEpoch'] as num).toInt(),
      );
    }
    return null;
  }
}

class InvoicePartyDetails {
  final String legalName;
  final String address;
  final String businessId;
  final String displayName;
  final String email;
  final String url;

  const InvoicePartyDetails({
    required this.legalName,
    required this.address,
    required this.businessId,
    this.displayName = '',
    this.email = '',
    this.url = '',
  });

  factory InvoicePartyDetails.fromJson(Map<String, dynamic> json) {
    return InvoicePartyDetails(
      legalName: json['legalName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      businessId: json['businessId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

class InvoiceLineItem {
  final String pricingId;
  final String description;
  final int quantity;
  final int unitGrossCents;
  final int grossCents;
  final int netCents;
  final int vatCents;
  final double vatRate;

  const InvoiceLineItem({
    required this.pricingId,
    required this.description,
    required this.quantity,
    required this.unitGrossCents,
    required this.grossCents,
    required this.netCents,
    required this.vatCents,
    required this.vatRate,
  });

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) {
    return InvoiceLineItem(
      pricingId: json['pricingId'] as String? ?? '',
      description: json['description'] as String? ?? 'Ticket',
      quantity: _readInt(json['quantity']),
      unitGrossCents: _readInt(json['unitGrossCents']),
      grossCents: _readInt(json['grossCents']),
      netCents: _readInt(json['netCents']),
      vatCents: _readInt(json['vatCents']),
      vatRate: _readDouble(json['vatRate']),
    );
  }
}

class InvoiceVatBreakdown {
  final double vatRate;
  final int grossCents;
  final int netCents;
  final int vatCents;

  const InvoiceVatBreakdown({
    required this.vatRate,
    required this.grossCents,
    required this.netCents,
    required this.vatCents,
  });

  factory InvoiceVatBreakdown.fromJson(Map<String, dynamic> json) {
    return InvoiceVatBreakdown(
      vatRate: _readDouble(json['vatRate']),
      grossCents: _readInt(json['grossCents']),
      netCents: _readInt(json['netCents']),
      vatCents: _readInt(json['vatCents']),
    );
  }
}

class InvoiceTotals {
  final String currency;
  final int grossCents;
  final int netCents;
  final int vatCents;
  final List<InvoiceVatBreakdown> vatBreakdown;

  const InvoiceTotals({
    required this.currency,
    required this.grossCents,
    required this.netCents,
    required this.vatCents,
    required this.vatBreakdown,
  });

  factory InvoiceTotals.fromJson(Map<String, dynamic> json) {
    return InvoiceTotals(
      currency: json['currency'] as String? ?? 'EUR',
      grossCents: _readInt(json['grossCents']),
      netCents: _readInt(json['netCents']),
      vatCents: _readInt(json['vatCents']),
      vatBreakdown: _readMapList(
        json['vatBreakdown'],
      ).map(InvoiceVatBreakdown.fromJson).toList(),
    );
  }
}

class InvoiceDetails {
  final String id;
  final String bookingId;
  final String account;
  final String displayInvoiceNumber;
  final DateTime? createdAt;
  final String status;
  final InvoicePartyDetails issuer;
  final InvoicePartyDetails recipient;
  final Map<String, dynamic> booking;
  final Map<String, dynamic> customerGroup;
  final Map<String, dynamic> tour;
  final List<Map<String, dynamic>> customers;
  final List<InvoiceLineItem> lineItems;
  final InvoiceTotals totals;

  const InvoiceDetails({
    required this.id,
    required this.bookingId,
    required this.account,
    required this.displayInvoiceNumber,
    required this.createdAt,
    required this.status,
    required this.issuer,
    required this.recipient,
    required this.booking,
    required this.customerGroup,
    required this.tour,
    required this.customers,
    required this.lineItems,
    required this.totals,
  });

  factory InvoiceDetails.fromJson(Map<String, dynamic> json, {String? id}) {
    return InvoiceDetails(
      id: id ?? json['id'] as String? ?? json['bookingId'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? id ?? '',
      account: json['account'] as String? ?? '',
      displayInvoiceNumber:
          json['displayInvoiceNumber'] as String? ??
          InvoiceSummary._fallbackInvoiceNumber(json),
      createdAt: InvoiceSummary._readDateTime(json['createdAt']),
      status: json['status'] as String? ?? '',
      issuer: InvoicePartyDetails.fromJson(_readMap(json['issuer'])),
      recipient: InvoicePartyDetails.fromJson(_readMap(json['recipient'])),
      booking: _readMap(json['booking']),
      customerGroup: _readMap(json['customerGroup']),
      tour: _readMap(json['tour']),
      customers: _readMapList(json['customers']),
      lineItems: _readMapList(
        json['lineItems'],
      ).map(InvoiceLineItem.fromJson).toList(),
      totals: InvoiceTotals.fromJson(_readMap(json['totals'])),
    );
  }
}

class InvoiceRecipientDetails {
  final String legalName;
  final String address;
  final String businessId;

  const InvoiceRecipientDetails({
    required this.legalName,
    required this.address,
    required this.businessId,
  });

  bool get isComplete =>
      legalName.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      businessId.trim().isNotEmpty;

  Map<String, dynamic> toJson() => {
    'legalName': legalName.trim(),
    'address': address.trim(),
    'businessId': businessId.trim(),
  };
}

class BookingInvoiceRow {
  final Booking booking;
  final CustomerGroup? customerGroup;
  final Partner? partner;
  final InvoiceSummary? invoice;

  const BookingInvoiceRow({
    required this.booking,
    required this.customerGroup,
    required this.partner,
    required this.invoice,
  });

  DateTime? get bookingCreatedOn => booking.createdOn;

  bool get hasInvoice => invoice != null;
}

enum InvoiceStatusFilter { all, created, missing }

Map<String, dynamic> _readMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}

List<Map<String, dynamic>> _readMapList(Object? value) {
  if (value is! List) return const [];
  return value.map(_readMap).toList();
}

int _readInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}

double _readDouble(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return 0;
}
