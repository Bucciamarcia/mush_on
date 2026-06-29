import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/customer_management/bookings/bookings_logic.dart';
import 'package:mush_on/customer_management/bookings/invoice_models.dart';
import 'package:mush_on/customer_management/bookings/invoice_repository.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/invoicing_details_form.dart';
import 'package:rxdart/rxdart.dart';

final bookingInvoiceRowsProvider =
    StreamProvider.autoDispose<List<BookingInvoiceRow>>((ref) async* {
      final account = await ref.watch(accountProvider.future);
      final repository = BookingInvoicesRepository(account: account);
      yield* Rx.combineLatest4(
        repository.watchBookings(),
        repository.watchCustomerGroups(),
        repository.watchPartners(),
        repository.watchInvoices(),
        (
          List<Booking> bookings,
          List<CustomerGroup> customerGroups,
          partners,
          invoices,
        ) => buildBookingInvoiceRows(
          bookings: bookings,
          customerGroups: customerGroups,
          partners: partners,
          invoices: invoices,
        ),
      );
    });

class BookingsInvoiceTab extends ConsumerStatefulWidget {
  const BookingsInvoiceTab({super.key});

  @override
  ConsumerState<BookingsInvoiceTab> createState() => _BookingsInvoiceTabState();
}

class _BookingsInvoiceTabState extends ConsumerState<BookingsInvoiceTab> {
  final _searchController = TextEditingController();
  InvoiceStatusFilter _statusFilter = InvoiceStatusFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rowsValue = ref.watch(bookingInvoiceRowsProvider);

    return rowsValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Could not load bookings: $error')),
      data: (rows) {
        final filteredRows = filterBookingInvoiceRows(
          rows: rows,
          query: _searchController.text,
          statusFilter: _statusFilter,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BookingsToolbar(
              searchController: _searchController,
              statusFilter: _statusFilter,
              onStatusChanged: (value) => setState(() => _statusFilter = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredRows.isEmpty
                  ? const _BookingsEmptyState()
                  : ListView.separated(
                      itemCount: filteredRows.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return _BookingInvoiceRowTile(row: filteredRows[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _BookingsToolbar extends StatelessWidget {
  final TextEditingController searchController;
  final InvoiceStatusFilter statusFilter;
  final ValueChanged<InvoiceStatusFilter> onStatusChanged;

  const _BookingsToolbar({
    required this.searchController,
    required this.statusFilter,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final search = TextField(
          controller: searchController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Search bookings',
            hintText: 'Try 2026-07-01, 01-07-2026, reseller, booking',
            helperText: 'Date formats: yyyy-mm-dd, dd-mm-yyyy, d.m.yyyy',
            border: OutlineInputBorder(),
          ),
        );
        final filter = SegmentedButton<InvoiceStatusFilter>(
          segments: const [
            ButtonSegment(
              value: InvoiceStatusFilter.all,
              label: Text('All'),
              icon: Icon(Icons.list_alt),
            ),
            ButtonSegment(
              value: InvoiceStatusFilter.created,
              label: Text('Invoiced'),
              icon: Icon(Icons.receipt_long),
            ),
            ButtonSegment(
              value: InvoiceStatusFilter.missing,
              label: Text('Missing'),
              icon: Icon(Icons.pending_actions),
            ),
          ],
          selected: {statusFilter},
          onSelectionChanged: (value) => onStatusChanged(value.first),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [search, const SizedBox(height: 8), filter],
          );
        }
        return Row(
          children: [
            Expanded(child: search),
            const SizedBox(width: 12),
            filter,
          ],
        );
      },
    );
  }
}

class _BookingInvoiceRowTile extends ConsumerStatefulWidget {
  final BookingInvoiceRow row;

  const _BookingInvoiceRowTile({required this.row});

  @override
  ConsumerState<_BookingInvoiceRowTile> createState() =>
      _BookingInvoiceRowTileState();
}

class _BookingInvoiceRowTileState
    extends ConsumerState<_BookingInvoiceRowTile> {
  bool _generating = false;
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    final dateFormat = DateFormat('dd MMM yyyy HH:mm');
    final bookingCreatedOn = row.bookingCreatedOn == null
        ? 'No booking date'
        : 'Booked ${dateFormat.format(row.bookingCreatedOn!)}';
    final partnerName = row.partner?.name.trim();
    final total = row.booking.totalCents == null
        ? null
        : NumberFormat.simpleCurrency(
            name: 'EUR',
          ).format(row.booking.totalCents! / 100);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: row.customerGroup == null
            ? null
            : () => context.goNamed(
                'customerGroupViewer',
                queryParameters: {'customerGroupId': row.customerGroup!.id},
              ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 720;
              final details = _BookingRowDetails(
                title: row.booking.name.isEmpty ? 'Booking' : row.booking.name,
                bookingCreatedOn: bookingCreatedOn,
                customerGroup:
                    row.customerGroup?.name ?? 'Unknown customer group',
                partner: partnerName == null || partnerName.isEmpty
                    ? null
                    : 'Partner: $partnerName',
                email: row.booking.email,
                total: total,
                paymentStatus: _paymentStatusLabel(row.booking.paymentStatus),
              );
              final actions = _BookingRowActions(
                row: row,
                generating: _generating,
                sending: _sending,
                onGenerate: _generateInvoice,
                onSend: _sendInvoice,
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    details,
                    const SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: actions),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: details),
                  const SizedBox(width: 16),
                  actions,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _generateInvoice() async {
    final row = widget.row;
    final account = await ref.read(accountProvider.future);
    if (!mounted) return;
    final repository = BookingInvoicesRepository(account: account);
    final recipient =
        partnerInvoiceRecipient(row.partner) ??
        await _askRecipientDetails(context, row);
    if (recipient == null) return;

    setState(() => _generating = true);
    try {
      final invoice = await repository.generateInvoice(
        bookingId: row.booking.id,
        recipient: recipient,
      );
      ref.invalidate(bookingInvoiceRowsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        confirmationSnackbar(
          context,
          invoice.displayInvoiceNumber.isEmpty
              ? 'Invoice generated'
              : 'Invoice ${invoice.displayInvoiceNumber} generated',
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(context, _invoiceGenerationErrorMessage(error)),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _sendInvoice() async {
    final row = widget.row;
    final email = await _askInvoiceEmail(context, row);
    if (email == null) return;

    setState(() => _sending = true);
    try {
      final account = await ref.read(accountProvider.future);
      final repository = BookingInvoicesRepository(account: account);
      await repository.sendInvoiceEmail(
        bookingId: row.booking.id,
        email: email,
      );
      ref.invalidate(bookingInvoiceRowsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(confirmationSnackbar(context, 'Invoice sent to $email'));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackBar(context, _invoiceActionErrorMessage(error)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}

String _invoiceGenerationErrorMessage(Object error) {
  return _invoiceActionErrorMessage(
    error,
    fallback: 'Could not generate invoice.',
  );
}

String _invoiceActionErrorMessage(
  Object error, {
  String fallback = 'Could not send invoice.',
}) {
  if (error is FirebaseFunctionsException) {
    final message = error.message?.trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }
  }
  return fallback;
}

class _BookingRowDetails extends StatelessWidget {
  final String title;
  final String bookingCreatedOn;
  final String customerGroup;
  final String? partner;
  final String? email;
  final String? total;
  final String paymentStatus;

  const _BookingRowDetails({
    required this.title,
    required this.bookingCreatedOn,
    required this.customerGroup,
    required this.partner,
    required this.email,
    required this.total,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 14,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _MetaText(icon: Icons.schedule, text: bookingCreatedOn),
            _MetaText(icon: Icons.route, text: customerGroup),
            if (partner != null && partner!.trim().isNotEmpty)
              _MetaText(icon: Icons.handshake_outlined, text: partner!.trim()),
            if (email != null && email!.trim().isNotEmpty)
              _MetaText(icon: Icons.mail_outline, text: email!.trim()),
            if (total != null) _MetaText(icon: Icons.euro, text: total!),
            _MetaText(icon: Icons.payments_outlined, text: paymentStatus),
          ],
        ),
      ],
    );
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(text, overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
      ],
    );
  }
}

class _BookingRowActions extends StatelessWidget {
  final BookingInvoiceRow row;
  final bool generating;
  final bool sending;
  final VoidCallback onGenerate;
  final VoidCallback onSend;

  const _BookingRowActions({
    required this.row,
    required this.generating,
    required this.sending,
    required this.onGenerate,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final invoice = row.invoice;
    if (invoice != null) {
      return Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Chip(
            avatar: const Icon(Icons.check_circle_outline, size: 18),
            label: Text(
              invoice.displayInvoiceNumber.isEmpty
                  ? 'Invoice created'
                  : invoice.displayInvoiceNumber,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => context.goNamed(
              'invoiceDetail',
              queryParameters: {'bookingId': row.booking.id},
            ),
            icon: const Icon(Icons.receipt_long),
            label: const Text('Show invoice'),
          ),
          Tooltip(
            message: 'Send invoice',
            child: IconButton.filledTonal(
              onPressed: sending ? null : onSend,
              icon: sending
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_outlined),
            ),
          ),
        ],
      );
    }
    if (!canGenerateInvoiceForBooking(row.booking)) {
      return Tooltip(
        message: 'Invoices cannot be generated for refunded bookings.',
        child: FilledButton.icon(
          onPressed: null,
          icon: const Icon(Icons.receipt_long),
          label: const Text('Generate invoice'),
        ),
      );
    }
    return FilledButton.icon(
      onPressed: generating ? null : onGenerate,
      icon: generating
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.receipt_long),
      label: Text(generating ? 'Generating' : 'Generate invoice'),
    );
  }
}

class _BookingsEmptyState extends StatelessWidget {
  const _BookingsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('No bookings match the current filters.'),
      ),
    );
  }
}

Future<InvoiceRecipientDetails?> _askRecipientDetails(
  BuildContext context,
  BookingInvoiceRow row,
) {
  return showDialog<InvoiceRecipientDetails>(
    context: context,
    builder: (context) => _InvoiceRecipientDialog(row: row),
  );
}

Future<String?> _askInvoiceEmail(BuildContext context, BookingInvoiceRow row) {
  return showDialog<String>(
    context: context,
    builder: (context) =>
        _InvoiceEmailDialog(initialEmail: invoiceEmailRecipient(row)),
  );
}

class _InvoiceEmailDialog extends StatefulWidget {
  final String initialEmail;

  const _InvoiceEmailDialog({required this.initialEmail});

  @override
  State<_InvoiceEmailDialog> createState() => _InvoiceEmailDialogState();
}

class _InvoiceEmailDialogState extends State<_InvoiceEmailDialog> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send invoice'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: TextField(
          controller: _emailController,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.mail_outline),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () =>
              Navigator.of(context).pop(_emailController.text.trim()),
          icon: const Icon(Icons.send_outlined),
          label: const Text('Send'),
        ),
      ],
    );
  }
}

class _InvoiceRecipientDialog extends StatefulWidget {
  final BookingInvoiceRow row;

  const _InvoiceRecipientDialog({required this.row});

  @override
  State<_InvoiceRecipientDialog> createState() =>
      _InvoiceRecipientDialogState();
}

class _InvoiceRecipientDialogState extends State<_InvoiceRecipientDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _legalNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _businessIdController;

  @override
  void initState() {
    super.initState();
    final row = widget.row;
    _legalNameController = TextEditingController(
      text: row.partner?.invoiceLegalName.isNotEmpty == true
          ? row.partner!.invoiceLegalName
          : row.booking.name,
    );
    _addressController = TextEditingController(
      text: row.partner?.invoiceAddress ?? '',
    );
    _businessIdController = TextEditingController(
      text: row.partner?.invoiceBusinessId ?? '',
    );
  }

  @override
  void dispose() {
    _legalNameController.dispose();
    _addressController.dispose();
    _businessIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Invoice recipient'),
      content: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            child: InvoicingDetailsForm(
              legalNameController: _legalNameController,
              addressController: _addressController,
              businessIdController: _businessIdController,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            if (_formKey.currentState?.validate() != true) return;
            Navigator.of(context).pop(
              InvoiceRecipientDetails(
                legalName: _legalNameController.text,
                address: _addressController.text,
                businessId: _businessIdController.text,
              ),
            );
          },
          icon: const Icon(Icons.receipt_long),
          label: const Text('Generate'),
        ),
      ],
    );
  }
}

String _paymentStatusLabel(PaymentStatus status) {
  return switch (status) {
    PaymentStatus.paid => 'Paid',
    PaymentStatus.deferredPayment => 'Deferred payment',
    PaymentStatus.waiting => 'Waiting',
    PaymentStatus.refunded => 'Refunded',
    PaymentStatus.paidOffPlatform => 'Paid off-platform',
    PaymentStatus.unknown => 'Unknown',
  };
}
