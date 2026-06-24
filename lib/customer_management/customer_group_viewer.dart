import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/alert_editors/booking.dart';
import 'package:mush_on/customer_management/alert_editors/logic.dart';
import 'package:mush_on/customer_management/alert_editors/repository.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:mush_on/settings/stripe/riverpod.dart' as stripe;
import 'package:mush_on/settings/stripe/stripe_models.dart';
import 'package:intl/intl.dart';
import '../riverpod.dart';
import 'alert_editors/customer_group.dart';
import 'repository.dart';
import 'riverpod.dart';
import 'tours/models.dart';
import 'tours/riverpod.dart';

class CustomerGroupViewerScreen extends StatelessWidget {
  final String? customerGroupId;
  const CustomerGroupViewerScreen({super.key, required this.customerGroupId});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
      title: "View customer group",
      child: CustomerGroupViewer(customerGroupId: customerGroupId),
    );
  }
}

class CustomerGroupViewer extends ConsumerWidget {
  final String? customerGroupId;
  const CustomerGroupViewer({super.key, required this.customerGroupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (customerGroupId == null) {
      return const Center(child: Text("No customer group ID provided."));
    }
    final customerGroupAsync = ref.watch(
      CustomerGroupByIdProvider(customerGroupId!),
    );
    final List<Booking> bookings =
        ref
            .watch(
              bookingsByCustomerGroupIdProvider(
                customerGroupId!,
                includeInactive: true,
              ),
            )
            .value ??
        [];
    final List<Customer> customers =
        ref.watch(CustomersByCustomerGroupIdProvider(customerGroupId!)).value ??
        [];
    return customerGroupAsync.when(
      data: (customerGroup) {
        //Handle unknown errors.
        if (customerGroup == null) {
          BasicLogger().error("Couldn't load teamgroup: $customerGroupId");
          return const Text("Couldn't load teamgroup: null");
        }

        // Define the customers.
        TourType? tour;
        if (customerGroup.tourTypeId != null) {
          tour = ref
              .watch(tourTypeByIdProvider(customerGroup.tourTypeId!))
              .value;
        }
        List<TourTypePricing>? pricings;
        if (tour != null) {
          pricings = ref.watch(tourTypePricesProvider(tour.id)).value;
        }
        final kennelInfo = ref
            .watch(stripe.bookingManagerKennelInfoProvider())
            .valueOrNull;
        final userName = ref.watch(userNameProvider(null)).valueOrNull;
        final canRefundAll =
            (userName?.userLevel.rank ?? 0) >= UserLevel.musher.rank;
        final colorScheme = Theme.of(context).colorScheme;
        final confirmedBookings = bookings.active;
        final unconfirmedBookings = bookings
            .where((booking) => !bookings.active.contains(booking))
            .toList();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.group, color: colorScheme.primary, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          customerGroup.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimaryContainer,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: [
                          if (canRefundAll)
                            _RefundAllBookingsButton(bookings: bookings),
                          ElevatedButton.icon(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => CustomerGroupEditor(
                                customerGroup: customerGroup,
                              ),
                            ),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Edit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.secondary,
                              foregroundColor: colorScheme.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Overview
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            "Overview",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Date & Time
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat(
                              "EEEE, MMMM d, yyyy",
                            ).format(customerGroup.datetime),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat("HH:mm").format(customerGroup.datetime),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Customers: ${customers.length}/${customerGroup.maxCapacity}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (pricings != null) ...[
                        const SizedBox(height: 8),
                        getPricings(customers, pricings),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tour
              tour == null
                  ? Card(
                      elevation: 0,
                      color: colorScheme.errorContainer.withValues(alpha: 0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: colorScheme.error),
                            const SizedBox(width: 8),
                            Text(
                              "No tour selected",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.route, color: colorScheme.primary),
                                const SizedBox(width: 8),
                                Text(
                                  "Tour: ${tour.name}",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.straighten,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Distance: ${tour.distance} km",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Duration: ${minutesToHoursMinutes(tour.duration)}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            if (tour.notes != null &&
                                tour.notes!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.notes,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      tour.notes!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 16),

              // Bookings
              bookings.isEmpty
                  ? Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.2,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_busy,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "No bookings for this group",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 0,
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.event, color: colorScheme.primary),
                                const SizedBox(width: 8),
                                Text(
                                  "Bookings (${bookings.length})",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _BookingListSection(
                          title: "Confirmed bookings",
                          description:
                              "Paid and deferred bookings. These appear in the team builder and statistics.",
                          emptyText: "No confirmed bookings",
                          bookings: confirmedBookings,
                          customerGroup: customerGroup,
                          kennelInfo: kennelInfo,
                          pricings: pricings,
                        ),
                        if (unconfirmedBookings.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _BookingListSection(
                            title: "Not confirmed bookings",
                            description:
                                "These bookings are not confirmed and won't appear in the team builder or in the statistics.",
                            emptyText: "No not confirmed bookings",
                            bookings: unconfirmedBookings,
                            customerGroup: customerGroup,
                            kennelInfo: kennelInfo,
                            pricings: pricings,
                          ),
                        ],
                      ],
                    ),
            ],
          ),
        );
      },
      error: (e, s) {
        BasicLogger().error(
          "Error loading customer group: $customerGroupId",
          error: e,
          stackTrace: s,
        );
        return const Center(
          child: Text("Error: couldn't load the customer group."),
        );
      },
      loading: () => const Center(
        child: SizedBox.square(
          dimension: 150,
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

class _RefundAllBookingsButton extends StatelessWidget {
  final List<Booking> bookings;

  const _RefundAllBookingsButton({required this.bookings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final paidBookings = bookings
        .where((booking) => booking.paymentStatus.isOnPlatformPaid)
        .toList();
    return Tooltip(
      message: paidBookings.isEmpty
          ? "No paid Stripe bookings to refund"
          : "Refund all paid Stripe bookings",
      child: OutlinedButton.icon(
        onPressed: paidBookings.isEmpty
            ? null
            : () => showDialog(
                context: context,
                builder: (_) => _ConfirmRefundAllBookingsDialog(
                  bookings: bookings,
                  paidBookingsCount: paidBookings.length,
                ),
              ),
        icon: const Icon(Icons.replay_circle_filled_outlined, size: 18),
        label: const Text("Refund all bookings"),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.error,
          side: BorderSide(color: colorScheme.error),
        ),
      ),
    );
  }
}

class _ConfirmRefundAllBookingsDialog extends ConsumerStatefulWidget {
  final List<Booking> bookings;
  final int paidBookingsCount;

  const _ConfirmRefundAllBookingsDialog({
    required this.bookings,
    required this.paidBookingsCount,
  });

  @override
  ConsumerState<_ConfirmRefundAllBookingsDialog> createState() =>
      _ConfirmRefundAllBookingsDialogState();
}

class _ConfirmRefundAllBookingsDialogState
    extends ConsumerState<_ConfirmRefundAllBookingsDialog> {
  bool _isProcessing = false;

  Future<void> _refundAll() async {
    setState(() => _isProcessing = true);
    try {
      final account = await ref.read(accountProvider.future);
      final repo = AlertEditorsRepository(account: account);
      final result = await refundPaidBookingsOneByOne(
        widget.bookings,
        repo.refundBooking,
      );
      if (!mounted) return;
      ref.invalidate(bookingsByCustomerGroupIdProvider);
      if (result.completed) {
        ScaffoldMessenger.of(context).showSnackBar(
          confirmationSnackbar(
            context,
            "${result.refundedCount} bookings refunded",
          ),
        );
        Navigator.of(context).pop();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          context,
          "Refund stopped after ${result.refundedCount}/${result.attemptedCount} bookings.",
        ),
      );
    } catch (e, s) {
      BasicLogger().error(
        "Failed to refund all bookings",
        error: e,
        stackTrace: s,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(errorSnackBar(context, "Failed to refund all bookings"));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      title: const Text("Be careful!"),
      content: Text(
        "This will refund ${widget.paidBookingsCount} paid Stripe booking(s) "
        "one by one and remove those bookings from the group. Refunded, "
        "waiting, deferred, and paid off-platform bookings will be skipped. "
        "This CANNOT be reversed!",
      ),
      actions: [
        if (!_isProcessing)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Go back",
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        _isProcessing
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                onPressed: _refundAll,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(colorScheme.error),
                ),
                child: Text(
                  "Refund payments",
                  style: TextStyle(color: colorScheme.onError),
                ),
              ),
      ],
    );
  }
}

class _BookingListSection extends ConsumerWidget {
  final String title;
  final String description;
  final String emptyText;
  final List<Booking> bookings;
  final CustomerGroup customerGroup;
  final List<TourTypePricing>? pricings;
  final BookingManagerKennelInfo? kennelInfo;

  const _BookingListSection({
    required this.title,
    required this.description,
    required this.emptyText,
    required this.bookings,
    required this.customerGroup,
    required this.pricings,
    required this.kennelInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        if (bookings.isEmpty)
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    emptyText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...bookings.map(
            (booking) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: BookingCard(
                selectedCustomerGroup: customerGroup,
                kennelInfo: kennelInfo,
                pricings: pricings,
                booking: booking,
                customers:
                    ref.watch(customersByBookingIdProvider(booking.id)).value ??
                    [],
              ),
            ),
          ),
      ],
    );
  }
}

class BookingCard extends ConsumerWidget {
  final Booking booking;
  final List<Customer> customers;
  final List<TourTypePricing>? pricings;
  final BookingManagerKennelInfo? kennelInfo;
  final CustomerGroup selectedCustomerGroup;
  const BookingCard({
    super.key,
    required this.booking,
    required this.customers,
    required this.pricings,
    required this.kennelInfo,
    required this.selectedCustomerGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingTitle = booking.name.trim().isEmpty
        ? "Booking"
        : booking.name.trim();
    final statusStyle = _bookingStatusStyle(
      context,
      booking.displayPaymentStatus(DateTime.now()),
    );
    final contactRows = <({IconData icon, String label, String? value})>[
      (icon: Icons.phone_outlined, label: "Phone", value: booking.phone),
      (icon: Icons.email_outlined, label: "Email", value: booking.email),
      (
        icon: Icons.home_work_outlined,
        label: "Street address",
        value: booking.streetAddress,
      ),
      (
        icon: Icons.local_post_office_outlined,
        label: "Zip code",
        value: booking.zipCode,
      ),
      (icon: Icons.location_city_outlined, label: "City", value: booking.city),
      (icon: Icons.public, label: "Country", value: booking.country),
    ].where((row) => (row.value ?? "").trim().isNotEmpty).toList();
    final bookingCustomRows =
        kennelInfo?.bookingCustomFields
            .map(
              (field) => (
                icon: Icons.notes_outlined,
                label: field.name,
                value: booking.otherBookingData[field.name],
              ),
            )
            .where((row) => (row.value ?? "").trim().isNotEmpty)
            .toList() ??
        const <({IconData icon, String label, String? value})>[];
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (_) => BookingEditorAlert(
          selectedCustomerGroup: selectedCustomerGroup,
          onBookingDeleted: () async {
            final String account = await ref.watch(accountProvider.future);
            final customerRepo = CustomerManagementRepository(account: account);
            try {
              await customerRepo.deleteBooking(booking.id);
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(context, "Failed to delete booking."),
              );
            }
          },
          booking: booking,
          onBookingEdited: (nb) async {
            final String account = await ref.watch(accountProvider.future);
            final customerRepo = CustomerManagementRepository(account: account);
            await customerRepo.setBooking(nb);
            ref.invalidate(bookingsByCustomerGroupIdProvider);
          },
          onCustomersEdited: (ncs, id) async {
            final String account = await ref.watch(accountProvider.future);
            final customerRepo = CustomerManagementRepository(account: account);
            await customerRepo.setCustomers(ncs, booking.id);
            ref.invalidate(bookingsByCustomerGroupIdProvider);
          },
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        color: statusStyle.background,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bookmark, color: statusStyle.foreground, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bookingTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: statusStyle.foreground,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.edit,
                    color: statusStyle.foreground.withValues(alpha: 0.7),
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    statusStyle.icon,
                    color: statusStyle.foreground.withValues(alpha: 0.85),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Status: ${statusStyle.label}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: statusStyle.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    color: statusStyle.foreground.withValues(alpha: 0.8),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "People: ${customers.length}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: statusStyle.foreground,
                    ),
                  ),
                ],
              ),
              if (pricings != null) ...[
                const SizedBox(height: 8),
                getPricings(customers, pricings!),
              ],
              if (booking.paymentStatus == PaymentStatus.deferredPayment) ...[
                const SizedBox(height: 12),
                _DeferredBookingActions(booking: booking),
              ],
              if (contactRows.isNotEmpty || bookingCustomRows.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [...contactRows, ...bookingCustomRows]
                      .map(
                        (row) => _InfoChip(
                          icon: row.icon,
                          label: row.label,
                          value: row.value!,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

({Color background, Color foreground, IconData icon, String label})
_bookingStatusStyle(BuildContext context, BookingPaymentDisplayStatus status) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (status) {
    BookingPaymentDisplayStatus.paid => (
      background: colorScheme.primaryContainer,
      foreground: colorScheme.onPrimaryContainer,
      icon: Icons.check_circle_outline,
      label: "Paid",
    ),
    BookingPaymentDisplayStatus.deferredPayment => (
      background: colorScheme.tertiaryContainer,
      foreground: colorScheme.onTertiaryContainer,
      icon: Icons.schedule_outlined,
      label: "Deferred",
    ),
    BookingPaymentDisplayStatus.paidOffPlatform => (
      background: colorScheme.primaryContainer,
      foreground: colorScheme.onPrimaryContainer,
      icon: Icons.payments_outlined,
      label: "Paid (off-platform)",
    ),
    BookingPaymentDisplayStatus.waiting => (
      background: colorScheme.surfaceContainerHighest,
      foreground: colorScheme.onSurface,
      icon: Icons.hourglass_top_outlined,
      label: "Waiting for payment",
    ),
    BookingPaymentDisplayStatus.paymentCancelled => (
      background: colorScheme.surfaceContainerHighest,
      foreground: colorScheme.onSurfaceVariant,
      icon: Icons.event_busy_outlined,
      label: "Payment cancelled",
    ),
    BookingPaymentDisplayStatus.refunded => (
      background: colorScheme.errorContainer,
      foreground: colorScheme.onErrorContainer,
      icon: Icons.replay_circle_filled_outlined,
      label: "Refunded",
    ),
    BookingPaymentDisplayStatus.unknown => (
      background: colorScheme.surfaceContainerHighest,
      foreground: colorScheme.onSurface,
      icon: Icons.help_outline,
      label: "Unknown",
    ),
  };
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: value),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

/// Actions shown on a deferred booking: (re)send the partner payment email and
/// mark the booking paid off-platform.
class _DeferredBookingActions extends ConsumerStatefulWidget {
  final Booking booking;
  const _DeferredBookingActions({required this.booking});

  @override
  ConsumerState<_DeferredBookingActions> createState() =>
      _DeferredBookingActionsState();
}

class _DeferredBookingActionsState
    extends ConsumerState<_DeferredBookingActions> {
  bool _isProcessing = false;

  Future<void> _run(
    Future<void> Function(AlertEditorsRepository repo) action,
    String successMessage,
    String errorMessage,
  ) async {
    setState(() => _isProcessing = true);
    try {
      final account = await ref.read(accountProvider.future);
      final repo = AlertEditorsRepository(account: account);
      await action(repo);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(confirmationSnackbar(context, successMessage));
      }
      ref.invalidate(bookingsByCustomerGroupIdProvider);
    } catch (e, s) {
      BasicLogger().error(errorMessage, error: e, stackTrace: s);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(errorSnackBar(context, errorMessage));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () => _run(
            (repo) => repo.sendDeferredPaymentEmail(widget.booking),
            "Payment email sent to partner",
            "Failed to send payment email",
          ),
          icon: const Icon(Icons.mail_outline, size: 18),
          label: const Text("Send payment email"),
        ),
        OutlinedButton.icon(
          onPressed: () => _run(
            (repo) => repo.markBookingPaidOffPlatform(widget.booking),
            "Booking marked paid (off-platform)",
            "Failed to mark booking paid",
          ),
          icon: const Icon(Icons.payments_outlined, size: 18),
          label: const Text("Mark paid (off-platform)"),
        ),
      ],
    );
  }
}

Widget getPricings(List<Customer> customers, List<TourTypePricing> pricings) {
  List<Widget> pricingWidgets = [];

  for (var price in pricings) {
    List<Customer> customerWithPrice = customers
        .where((c) => c.pricingId != null && c.pricingId == price.id)
        .toList();
    if (customerWithPrice.isNotEmpty) {
      pricingWidgets.add(
        Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${price.name}: ${customerWithPrice.length}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  if (pricingWidgets.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: pricingWidgets,
  );
}

String minutesToHoursMinutes(int totalMinutes) {
  if (totalMinutes == 0) {
    return "0m";
  }

  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  if (hours == 0) {
    return "${minutes}m";
  } else if (minutes == 0) {
    return "${hours}h";
  } else {
    return "${hours}h ${minutes}m";
  }
}
