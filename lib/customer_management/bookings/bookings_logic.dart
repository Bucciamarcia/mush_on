import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/bookings/invoice_models.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/partners/models.dart';

List<BookingInvoiceRow> buildBookingInvoiceRows({
  required List<Booking> bookings,
  required List<CustomerGroup> customerGroups,
  required List<Partner> partners,
  required List<InvoiceSummary> invoices,
}) {
  final groupsById = {for (final group in customerGroups) group.id: group};
  final partnersById = {for (final partner in partners) partner.id: partner};
  final invoicesByBookingId = {
    for (final invoice in invoices) invoice.bookingId: invoice,
  };

  final rows = bookings
      .where((booking) => booking.paymentStatus != PaymentStatus.waiting)
      .map(
        (booking) => BookingInvoiceRow(
          booking: booking,
          customerGroup: groupsById[booking.customerGroupId],
          partner: booking.partner == null
              ? null
              : partnersById[booking.partner],
          invoice: invoicesByBookingId[booking.id],
        ),
      )
      .toList();

  rows.sort((a, b) {
    final aDate = a.bookingCreatedOn;
    final bDate = b.bookingCreatedOn;
    if (aDate == null && bDate == null) {
      return a.booking.name.compareTo(b.booking.name);
    }
    if (aDate == null) {
      return 1;
    }
    if (bDate == null) {
      return -1;
    }
    return bDate.compareTo(aDate);
  });
  return rows;
}

bool canGenerateInvoiceForBooking(Booking booking) {
  return booking.paymentStatus != PaymentStatus.refunded &&
      booking.paymentStatus != PaymentStatus.waiting;
}

List<BookingInvoiceRow> filterBookingInvoiceRows({
  required List<BookingInvoiceRow> rows,
  required String query,
  required InvoiceStatusFilter statusFilter,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  final dateFormat = DateFormat('yyyy-MM-dd dd-MM-yyyy d.M.yyyy');

  return rows.where((row) {
    final statusMatches = switch (statusFilter) {
      InvoiceStatusFilter.all => true,
      InvoiceStatusFilter.created => row.hasInvoice,
      InvoiceStatusFilter.missing => !row.hasInvoice,
    };
    if (!statusMatches) return false;
    if (normalizedQuery.isEmpty) return true;

    final dateText = row.bookingCreatedOn == null
        ? ''
        : dateFormat.format(row.bookingCreatedOn!);
    final searchable = [
      row.booking.name,
      row.booking.email ?? '',
      row.booking.phone ?? '',
      row.customerGroup?.name ?? '',
      row.partner?.name ?? '',
      row.partner?.code ?? '',
      row.invoice?.displayInvoiceNumber ?? '',
      dateText,
    ].join(' ').toLowerCase();
    return searchable.contains(normalizedQuery);
  }).toList();
}

InvoiceRecipientDetails? partnerInvoiceRecipient(Partner? partner) {
  if (partner == null || !partner.invoiceEnabled) return null;
  final details = InvoiceRecipientDetails(
    legalName: partner.invoiceLegalName,
    address: partner.invoiceAddress,
    businessId: partner.invoiceBusinessId,
  );
  return details.isComplete ? details : null;
}

String invoiceEmailRecipient(BookingInvoiceRow row) {
  final partnerEmail = row.partner?.email?.trim();
  if (partnerEmail != null && partnerEmail.isNotEmpty) {
    return partnerEmail;
  }
  return row.booking.email?.trim() ?? '';
}
