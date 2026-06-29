import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/bookings/invoice_models.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Uint8List buildInvoicePdf(InvoiceDetails invoice) {
  final document = PdfDocument();
  document.pageSettings.size = PdfPageSize.a4;
  document.pageSettings.margins.all = 32;
  document.documentInformation.title = invoiceDisplayNumber(invoice);

  final page = document.pages.add();
  final bounds = page.getClientSize();
  final graphics = page.graphics;
  final regular = PdfStandardFont(PdfFontFamily.helvetica, 10);
  final small = PdfStandardFont(PdfFontFamily.helvetica, 8);
  final label = PdfStandardFont(
    PdfFontFamily.helvetica,
    8,
    style: PdfFontStyle.bold,
  );
  final title = PdfStandardFont(
    PdfFontFamily.helvetica,
    26,
    style: PdfFontStyle.bold,
  );
  final section = PdfStandardFont(
    PdfFontFamily.helvetica,
    12,
    style: PdfFontStyle.bold,
  );
  final total = PdfStandardFont(
    PdfFontFamily.helvetica,
    11,
    style: PdfFontStyle.bold,
  );
  final primaryBrush = PdfSolidBrush(PdfColor(31, 74, 92));
  final mutedBrush = PdfSolidBrush(PdfColor(88, 99, 106));
  final fillBrush = PdfSolidBrush(PdfColor(239, 244, 246));
  final borderPen = PdfPen(PdfColor(207, 216, 220));

  final invoiceNumber = invoiceDisplayNumber(invoice);
  graphics.drawString(
    'Invoice',
    title,
    brush: primaryBrush,
    bounds: Rect.fromLTWH(0, 0, bounds.width * 0.55, 34),
  );
  graphics.drawString(
    invoiceNumber,
    section,
    brush: PdfBrushes.black,
    bounds: Rect.fromLTWH(0, 36, bounds.width * 0.55, 18),
  );

  _drawLabelValue(
    graphics,
    label,
    regular,
    'Created',
    _dateTime(invoice.createdAt),
    Rect.fromLTWH(bounds.width - 170, 2, 170, 30),
    alignRight: true,
    labelBrush: mutedBrush,
  );
  _drawLabelValue(
    graphics,
    label,
    regular,
    'Booking',
    invoice.bookingId,
    Rect.fromLTWH(bounds.width - 170, 36, 170, 36),
    alignRight: true,
    labelBrush: mutedBrush,
  );

  var y = 92.0;
  final partyWidth = (bounds.width - 24) / 2;
  final issuerHeight = _drawParty(
    graphics,
    section,
    regular,
    label,
    'Issuer',
    invoice.issuer,
    Rect.fromLTWH(0, y, partyWidth, 100),
    primaryBrush,
    mutedBrush,
  );
  final recipientHeight = _drawParty(
    graphics,
    section,
    regular,
    label,
    'Recipient',
    invoice.recipient,
    Rect.fromLTWH(partyWidth + 24, y, partyWidth, 100),
    primaryBrush,
    mutedBrush,
  );
  y += (issuerHeight > recipientHeight ? issuerHeight : recipientHeight) + 28;

  final groupDate = _readDateTime(invoice.customerGroup['datetime']);
  final bookingCreatedOn = _readDateTime(invoice.booking['createdOn']);
  final summary = [
    (
      'Tour',
      _firstText([
        invoice.tour['displayName'],
        invoice.tour['name'],
        invoice.customerGroup['name'],
      ]),
    ),
    ('Trip date', _dateTime(groupDate)),
    ('Booked', _dateTime(bookingCreatedOn)),
    ('Booking name', _firstText([invoice.booking['name'], invoice.bookingId])),
  ];
  graphics.drawRectangle(
    bounds: Rect.fromLTWH(0, y, bounds.width, 54),
    brush: fillBrush,
  );
  final summaryWidth = bounds.width / summary.length;
  for (var i = 0; i < summary.length; i++) {
    _drawLabelValue(
      graphics,
      label,
      small,
      summary[i].$1,
      summary[i].$2,
      Rect.fromLTWH(12 + summaryWidth * i, y + 10, summaryWidth - 18, 34),
      labelBrush: mutedBrush,
    );
  }
  y += 82;

  final grid = _buildLineItemsGrid(invoice, regular, label);
  final gridResult = grid.draw(
    page: page,
    bounds: Rect.fromLTWH(0, y, bounds.width, 0),
  );
  y = (gridResult?.bounds.bottom ?? y) + 24;

  if (invoice.reverseChargeVat) {
    graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, y, bounds.width, 28),
      pen: borderPen,
      brush: fillBrush,
    );
    graphics.drawString(
      'VAT reverse charged',
      total,
      bounds: Rect.fromLTWH(10, y + 8, bounds.width - 20, 14),
    );
    y += 44;
  }

  const totalsWidth = 210.0;
  var totalsY = y;
  for (final vat in invoice.totals.vatBreakdown) {
    _drawTotalLine(
      graphics,
      regular,
      'VAT ${_vatRate(vat.vatRate)}',
      _money(vat.vatCents),
      Rect.fromLTWH(bounds.width - totalsWidth, totalsY, totalsWidth, 16),
    );
    totalsY += 18;
  }
  graphics.drawLine(
    borderPen,
    Offset(bounds.width - totalsWidth, totalsY + 4),
    Offset(bounds.width, totalsY + 4),
  );
  totalsY += 14;
  _drawTotalLine(
    graphics,
    regular,
    'Net total',
    _money(invoice.totals.netCents),
    Rect.fromLTWH(bounds.width - totalsWidth, totalsY, totalsWidth, 16),
  );
  totalsY += 18;
  _drawTotalLine(
    graphics,
    regular,
    'VAT total',
    _money(invoice.totals.vatCents),
    Rect.fromLTWH(bounds.width - totalsWidth, totalsY, totalsWidth, 16),
  );
  totalsY += 22;
  _drawTotalLine(
    graphics,
    total,
    'Gross total',
    _money(invoice.totals.grossCents),
    Rect.fromLTWH(bounds.width - totalsWidth, totalsY, totalsWidth, 18),
  );

  final bytes = Uint8List.fromList(document.saveSync());
  document.dispose();
  return bytes;
}

String invoicePdfFilename(InvoiceDetails invoice) {
  final raw = invoiceDisplayNumber(invoice);
  final sanitized = raw
      .replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return sanitized.isEmpty ? 'invoice' : sanitized;
}

String invoiceDisplayNumber(InvoiceDetails invoice) {
  final values = [invoice.displayInvoiceNumber, invoice.id, invoice.bookingId];
  for (final value in values) {
    final text = value.trim();
    if (text.isNotEmpty) return text;
  }
  return 'invoice';
}

PdfGrid _buildLineItemsGrid(
  InvoiceDetails invoice,
  PdfFont regular,
  PdfFont label,
) {
  final grid = PdfGrid();
  grid.columns.add(count: 6);
  grid.columns[0].width = 170;
  grid.columns[1].width = 38;
  grid.columns[2].width = 76;
  grid.columns[3].width = 48;
  grid.columns[4].width = 74;
  grid.columns[5].width = 76;

  final header = grid.headers.add(1)[0];
  header.style.backgroundBrush = PdfSolidBrush(PdfColor(31, 74, 92));
  header.style.textBrush = PdfBrushes.white;
  header.style.font = label;
  final headings = ['Description', 'Qty', 'Unit gross', 'VAT', 'Net', 'Total'];
  for (var i = 0; i < headings.length; i++) {
    header.cells[i].value = headings[i];
    header.cells[i].style.cellPadding = PdfPaddings(
      left: 5,
      right: 5,
      top: 5,
      bottom: 5,
    );
  }

  for (final line in invoice.lineItems) {
    final row = grid.rows.add();
    row.style.font = regular;
    row.cells[0].value = line.description;
    row.cells[1].value = line.quantity.toString();
    row.cells[2].value = _money(line.unitGrossCents);
    row.cells[3].value = _vatRate(line.vatRate);
    row.cells[4].value = _money(line.netCents);
    row.cells[5].value = _money(line.grossCents);
    for (var i = 0; i < row.cells.count; i++) {
      row.cells[i].style.cellPadding = PdfPaddings(
        left: 5,
        right: 5,
        top: 5,
        bottom: 5,
      );
      if (i > 0) {
        row.cells[i].stringFormat.alignment = PdfTextAlignment.right;
      }
    }
  }

  grid.style.cellSpacing = 0;
  return grid;
}

double _drawParty(
  PdfGraphics graphics,
  PdfFont section,
  PdfFont regular,
  PdfFont label,
  String title,
  InvoicePartyDetails party,
  Rect bounds,
  PdfBrush titleBrush,
  PdfBrush mutedBrush,
) {
  graphics.drawString(
    title,
    section,
    brush: titleBrush,
    bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 18),
  );
  var y = bounds.top + 24;
  final values = [
    if (party.legalName.isNotEmpty) party.legalName,
    if (party.address.isNotEmpty) party.address,
    if (party.businessId.isNotEmpty) 'Business ID / VAT: ${party.businessId}',
    if (party.email.isNotEmpty) party.email,
    if (party.url.isNotEmpty) party.url,
  ];
  if (values.isEmpty) {
    graphics.drawString(
      '-',
      regular,
      brush: mutedBrush,
      bounds: Rect.fromLTWH(bounds.left, y, bounds.width, 14),
    );
    return 42;
  }
  for (final value in values) {
    y = _drawWrappedText(
      graphics,
      regular,
      value,
      Rect.fromLTWH(bounds.left, y, bounds.width, 0),
      lineHeight: 13,
    );
    y += 3;
  }
  return y - bounds.top;
}

double _drawWrappedText(
  PdfGraphics graphics,
  PdfFont font,
  String text,
  Rect bounds, {
  required double lineHeight,
}) {
  var y = bounds.top;
  final lines = _wrapText(text, font, bounds.width);
  for (final line in lines) {
    graphics.drawString(
      line,
      font,
      bounds: Rect.fromLTWH(bounds.left, y, bounds.width, lineHeight),
    );
    y += lineHeight;
  }
  return y;
}

List<String> _wrapText(String text, PdfFont font, double maxWidth) {
  final lines = <String>[];
  final paragraphs = text
      .split(RegExp(r'\r?\n'))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty);

  for (final paragraph in paragraphs) {
    final words = paragraph.split(RegExp(r'\s+'));
    var current = '';
    for (final word in words) {
      final candidate = current.isEmpty ? word : '$current $word';
      if (current.isNotEmpty &&
          font.measureString(candidate).width > maxWidth) {
        lines.add(current);
        current = word;
      } else {
        current = candidate;
      }
    }
    if (current.isNotEmpty) lines.add(current);
  }

  return lines.isEmpty ? ['-'] : lines;
}

void _drawLabelValue(
  PdfGraphics graphics,
  PdfFont labelFont,
  PdfFont valueFont,
  String label,
  String value,
  Rect bounds, {
  bool alignRight = false,
  PdfBrush? labelBrush,
}) {
  final format = PdfStringFormat(
    alignment: alignRight ? PdfTextAlignment.right : PdfTextAlignment.left,
  );
  graphics.drawString(
    label,
    labelFont,
    brush: labelBrush,
    bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 10),
    format: format,
  );
  graphics.drawString(
    value,
    valueFont,
    bounds: Rect.fromLTWH(
      bounds.left,
      bounds.top + 14,
      bounds.width,
      bounds.height - 14,
    ),
    format: format,
  );
}

void _drawTotalLine(
  PdfGraphics graphics,
  PdfFont font,
  String label,
  String value,
  Rect bounds,
) {
  graphics.drawString(label, font, bounds: bounds);
  graphics.drawString(
    value,
    font,
    bounds: bounds,
    format: PdfStringFormat(alignment: PdfTextAlignment.right),
  );
}

String _money(int cents) {
  return NumberFormat.simpleCurrency(name: 'EUR').format(cents / 100);
}

String _vatRate(double rate) {
  final percent = rate * 100;
  return '${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%';
}

String _dateTime(DateTime? value) {
  if (value == null) return '-';
  return DateFormat('dd MMM yyyy HH:mm').format(value);
}

String _firstText(List<Object?> values) {
  for (final value in values) {
    final text = value?.toString().trim() ?? '';
    if (text.isNotEmpty) return text;
  }
  return '-';
}

DateTime? _readDateTime(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return null;
}
