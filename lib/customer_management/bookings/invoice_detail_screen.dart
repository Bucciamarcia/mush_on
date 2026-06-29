import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/bookings/invoice_models.dart';
import 'package:mush_on/customer_management/bookings/invoice_repository.dart';
import 'package:mush_on/customer_management/bookings/invoice_print_stub.dart'
    if (dart.library.html) 'package:mush_on/customer_management/bookings/invoice_print_web.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

final invoiceDetailsProvider = StreamProvider.autoDispose
    .family<InvoiceDetails?, String>((ref, bookingId) async* {
      final account = await ref.watch(accountProvider.future);
      final repository = BookingInvoicesRepository(account: account);
      yield* repository.watchInvoice(bookingId);
    });

final publicInvoiceDetailsProvider = FutureProvider.autoDispose
    .family<InvoiceDetails, PublicInvoiceLink>((ref, link) {
      return BookingInvoicesRepository.getPublicInvoice(
        account: link.account,
        bookingId: link.bookingId,
        token: link.token,
      );
    });

class PublicInvoiceLink {
  final String account;
  final String bookingId;
  final String token;

  const PublicInvoiceLink({
    required this.account,
    required this.bookingId,
    required this.token,
  });

  bool get isValid =>
      account.trim().isNotEmpty &&
      bookingId.trim().isNotEmpty &&
      token.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    return other is PublicInvoiceLink &&
        other.account == account &&
        other.bookingId == bookingId &&
        other.token == token;
  }

  @override
  int get hashCode => Object.hash(account, bookingId, token);
}

class InvoiceDetailScreen extends ConsumerWidget {
  final String? bookingId;

  const InvoiceDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = bookingId;
    if (id == null || id.isEmpty) {
      return const TemplateScreen(
        title: 'Invoice',
        child: Center(child: Text('Missing booking id.')),
      );
    }

    final invoiceValue = ref.watch(invoiceDetailsProvider(id));
    return TemplateScreen(
      title: 'Invoice',
      child: invoiceValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load invoice: $error')),
        data: (invoice) {
          if (invoice == null) {
            return const Center(child: Text('Invoice not found.'));
          }
          return _InvoicePage(invoice: invoice);
        },
      ),
    );
  }
}

class PublicInvoiceScreen extends ConsumerWidget {
  final PublicInvoiceLink link;

  const PublicInvoiceScreen({super.key, required this.link});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!link.isValid) {
      return const Scaffold(
        body: Center(child: Text('This invoice link is incomplete.')),
      );
    }
    final invoiceValue = ref.watch(publicInvoiceDetailsProvider(link));
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: invoiceValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Could not load invoice: $error')),
            data: (invoice) => _InvoicePage(invoice: invoice),
          ),
        ),
      ),
    );
  }
}

class _InvoicePage extends StatelessWidget {
  final InvoiceDetails invoice;

  const _InvoicePage({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () async {
              final didPrint = await printInvoicePage();
              if (!context.mounted) return;
              if (!didPrint) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar(
                    context,
                    'Printing is available from the web app.',
                  ),
                );
              }
            },
            icon: const Icon(Icons.print_outlined),
            label: const Text('Print / save PDF'),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: _InvoiceDocument(invoice: invoice),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InvoiceDocument extends StatelessWidget {
  final InvoiceDetails invoice;

  const _InvoiceDocument({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    invoice.displayInvoiceNumber.isEmpty
                        ? invoice.id
                        : invoice.displayInvoiceNumber,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _SmallLabelValue(
                  label: 'Created',
                  value: _dateTime(invoice.createdAt),
                  alignEnd: true,
                ),
                _SmallLabelValue(
                  label: 'Booking',
                  value: invoice.bookingId,
                  alignEnd: true,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 36),
        LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 680;
            final parties = [
              _PartyBlock(title: 'Issuer', party: invoice.issuer),
              _PartyBlock(title: 'Recipient', party: invoice.recipient),
            ];
            if (narrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [parties[0], const SizedBox(height: 24), parties[1]],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: parties[0]),
                const SizedBox(width: 48),
                Expanded(child: parties[1]),
              ],
            );
          },
        ),
        const SizedBox(height: 36),
        _BookingSummary(invoice: invoice),
        const SizedBox(height: 32),
        _LineItemsTable(invoice: invoice),
        const SizedBox(height: 28),
        _TotalsBlock(totals: invoice.totals),
      ],
    );
  }
}

class _PartyBlock extends StatelessWidget {
  final String title;
  final InvoicePartyDetails party;

  const _PartyBlock({required this.title, required this.party});

  @override
  Widget build(BuildContext context) {
    final values = [
      if (party.legalName.isNotEmpty) party.legalName,
      if (party.address.isNotEmpty) party.address,
      if (party.businessId.isNotEmpty) 'Business ID / VAT: ${party.businessId}',
      if (party.email.isNotEmpty) party.email,
      if (party.url.isNotEmpty) party.url,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ...values.map(
          (value) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(value),
          ),
        ),
      ],
    );
  }
}

class _BookingSummary extends StatelessWidget {
  final InvoiceDetails invoice;

  const _BookingSummary({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final groupDate = _readDateTime(invoice.customerGroup['datetime']);
    final bookingCreatedOn = _readDateTime(invoice.booking['createdOn']);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 28,
          runSpacing: 14,
          children: [
            _SmallLabelValue(
              label: 'Tour',
              value: _firstText([
                invoice.tour['displayName'],
                invoice.tour['name'],
                invoice.customerGroup['name'],
              ]),
            ),
            _SmallLabelValue(label: 'Trip date', value: _dateTime(groupDate)),
            _SmallLabelValue(
              label: 'Booked',
              value: _dateTime(bookingCreatedOn),
            ),
            _SmallLabelValue(
              label: 'Booking name',
              value: _firstText([invoice.booking['name'], invoice.bookingId]),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineItemsTable extends StatelessWidget {
  final InvoiceDetails invoice;

  const _LineItemsTable({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        columns: const [
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Qty'), numeric: true),
          DataColumn(label: Text('Unit gross'), numeric: true),
          DataColumn(label: Text('VAT'), numeric: true),
          DataColumn(label: Text('Net'), numeric: true),
          DataColumn(label: Text('Total'), numeric: true),
        ],
        rows: invoice.lineItems
            .map(
              (line) => DataRow(
                cells: [
                  DataCell(Text(line.description)),
                  DataCell(Text(line.quantity.toString())),
                  DataCell(Text(_money(line.unitGrossCents))),
                  DataCell(Text(_vatRate(line.vatRate))),
                  DataCell(Text(_money(line.netCents))),
                  DataCell(Text(_money(line.grossCents))),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TotalsBlock extends StatelessWidget {
  final InvoiceTotals totals;

  const _TotalsBlock({required this.totals});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          children: [
            ...totals.vatBreakdown.map(
              (vat) => _TotalLine(
                label: 'VAT ${_vatRate(vat.vatRate)}',
                value: _money(vat.vatCents),
              ),
            ),
            const Divider(height: 24),
            _TotalLine(label: 'Net total', value: _money(totals.netCents)),
            _TotalLine(label: 'VAT total', value: _money(totals.vatCents)),
            _TotalLine(
              label: 'Gross total',
              value: _money(totals.grossCents),
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalLine extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;

  const _TotalLine({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _SmallLabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _SmallLabelValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(value),
      ],
    );
  }
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
