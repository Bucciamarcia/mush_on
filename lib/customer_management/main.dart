import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/customer_management/alert_editors/booking.dart';
import 'package:mush_on/customer_management/alert_editors/customer_group.dart';
import 'package:mush_on/customer_management/repository.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'models.dart';

class ClientManagementMainScreen extends ConsumerWidget {
  static final logger = BasicLogger();
  const ClientManagementMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Data fetching remains the same
    final todaysCustomerGroups =
        ref.watch(customerGroupsByDayProvider(DateTimeUtils.today())).value ??
            [];
    final todaysOrphanedCustomerGroups =
        todaysCustomerGroups.where((cg) => cg.teamGroupId == null).toList();
    final todaysBookings =
        ref.watch(bookingsByDayProvider(DateTimeUtils.today())).value ?? [];
    final todaysOrphanedBookings =
        todaysBookings.where((b) => b.customerGroupId == null).toList();
    final futureBookings =
        ref.watch(futureBookingsProvider(untilDate: null)).value ?? [];
    final unpaidBookings = futureBookings.where((b) => !b.isFullyPaid).toList();
    final futureCustomerGroups =
        ref.watch(futureCustomerGroupsProvider(untilDate: null)).value ?? [];
    final customerGroupsWithoutTeamgroup =
        futureCustomerGroups.where((c) => c.teamGroupId == null).toList();
    final bookingsWithoutCustomerGroup =
        futureBookings.where((b) => b.customerGroupId == null).toList();

    final tomorrowCustomerGroups = ref
            .watch(futureCustomerGroupsProvider(
                untilDate: DateTimeUtils.today().add(const Duration(days: 2))))
            .value ??
        [];
    final next7DaysCustomerGroups = ref
            .watch(futureCustomerGroupsProvider(
                untilDate: DateTimeUtils.today().add(const Duration(days: 8))))
            .value ??
        [];

    final warnings = [
      if (todaysOrphanedCustomerGroups.isNotEmpty)
        _WarningSection(
          title: "Today's Orphaned Customer Groups",
          child:
              ListCustomerGroups(customerGroups: todaysOrphanedCustomerGroups),
        ),
      if (todaysOrphanedBookings.isNotEmpty)
        _WarningSection(
          title: "Today's Orphaned Bookings",
          child: ListBookings(
            bookings: todaysOrphanedBookings,
            customerGroups: todaysCustomerGroups,
          ),
        ),
      if (unpaidBookings.isNotEmpty)
        _WarningSection(
          title: "Future Unpaid Bookings",
          child: ListBookings(
            bookings: unpaidBookings,
            customerGroups: futureCustomerGroups,
          ),
        ),
      if (customerGroupsWithoutTeamgroup.isNotEmpty)
        _WarningSection(
          title: "Future Customer Groups Without a Team",
          child: ListCustomerGroups(
              customerGroups: customerGroupsWithoutTeamgroup),
        ),
      if (bookingsWithoutCustomerGroup.isNotEmpty)
        _WarningSection(
          title: "Future Bookings Without a Customer Group",
          child: ListBookings(
            bookings: bookingsWithoutCustomerGroup,
            customerGroups: futureCustomerGroups,
          ),
        ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          "Customer Management",
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Warnings Section
        if (warnings.isNotEmpty) ...[
          Card(
            color: Theme.of(context)
                .colorScheme
                .errorContainer
                .withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Action Required",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...warnings,
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Today's Overview
        _buildSectionTitle(context, "Today's Overview"),
        if (todaysCustomerGroups.isNotEmpty)
          ListCustomerGroups(customerGroups: todaysCustomerGroups)
        else
          const Text("No customer groups for today."),
        const SizedBox(height: 16),
        if (todaysBookings.isNotEmpty)
          ListBookings(
            bookings: todaysBookings,
            customerGroups: todaysCustomerGroups,
          )
        else
          const Text("No bookings for today."),
        const SizedBox(height: 24),

        // Future
        _buildSectionTitle(context, "Upcoming"),
        _buildExpansionTileChild(
          context,
          "Tomorrow",
          tomorrowCustomerGroups.isNotEmpty
              ? ListCustomerGroups(customerGroups: tomorrowCustomerGroups)
              : const Text("No customer groups for tomorrow."),
        ),
        _buildExpansionTileChild(
          context,
          "Next 7 Days",
          next7DaysCustomerGroups.isNotEmpty
              ? ListCustomerGroups(customerGroups: next7DaysCustomerGroups)
              : const Text("No customer groups for the next 7 days."),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildExpansionTileChild(
      BuildContext context, String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}

class _WarningSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _WarningSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

/// A list of the customer groups that can be clicked. In Column() form.
class ListCustomerGroups extends ConsumerWidget {
  final List<CustomerGroup> customerGroups;
  const ListCustomerGroups({super.key, required this.customerGroups});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);
    return Column(
      children: customerGroups.map(
        (cg) {
          final bookings =
              ref.watch(bookingsByCustomerGroupIdProvider(cg.id)).value ?? [];
          final teamGroup = (cg.teamGroupId != null)
              ? ref.watch(teamGroupByIdProvider(cg.teamGroupId!)).value
              : null;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => showDialog(
                context: context,
                builder: (_) => CustomerGroupEditorAlert(
                  onCustomerGroupDeleted: () =>
                      customerRepo.deleteCustomerGroup(cg.id).catchError(
                            (e) => ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(
                                  context, "Failed to delete customer group."),
                            ),
                          ),
                  customerGroup: cg,
                  onCgEdited: (ncg) async {
                    customerRepo.setCustomerGroup(ncg);
                    ref.invalidate(customerGroupsByDayProvider);
                    ref.invalidate(futureCustomerGroupsProvider);
                    ref.invalidate(teamGroupByIdProvider);
                  },
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cg.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat("dd-MM-yyyy 'at' hh:mm")
                              .format(cg.datetime),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        Chip(
                          avatar: Icon(
                              teamGroup == null
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle_outline_rounded,
                              size: 18),
                          label: Text(teamGroup == null
                              ? "No Team Assigned"
                              : teamGroup.name),
                          backgroundColor: teamGroup == null
                              ? Theme.of(context).colorScheme.errorContainer
                              : Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ],
                    ),
                    if (bookings.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text("Bookings:",
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 8),
                      ...bookings.map((b) => _BookingCardInGroup(booking: b)),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class _BookingCardInGroup extends ConsumerWidget {
  final Booking booking;

  const _BookingCardInGroup({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);
    final customers =
        ref.watch(customersByBookingIdProvider(booking.id)).value ?? [];

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12), // same as Card's shape
        onTap: () => showDialog(
          context: context,
          builder: (_) => BookingEditorAlert(
            booking: booking,
            onBookingDeleted: () async =>
                await customerRepo.deleteBooking(booking.id).catchError(
                      (e) => ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(context, "Failed to delete booking."),
                      ),
                    ),
            onBookingEdited: (nb) async {
              await customerRepo.setBooking(nb);
              ref.invalidate(bookingsByDayProvider);
              ref.invalidate(bookingsByCustomerGroupIdProvider);
              ref.invalidate(futureBookingsProvider);
            },
            onCustomersEdited: (ncs) async {
              await customerRepo.setCustomers(ncs, booking.id);
              ref.invalidate(bookingsByDayProvider);
              ref.invalidate(bookingsByCustomerGroupIdProvider);
              ref.invalidate(futureBookingsProvider);
            },
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.name),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Text("${customers.length} ppl"),
                  Chip(
                    label: Text(booking.isFullyPaid ? "Paid" : "Unpaid"),
                    padding: EdgeInsets.zero,
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    backgroundColor: booking.isFullyPaid
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// A list of the bookings that can be clicked. In Column() form.
class ListBookings extends ConsumerWidget {
  final List<Booking> bookings;
  final List<CustomerGroup> customerGroups;

  const ListBookings({
    super.key,
    required this.bookings,
    required this.customerGroups,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);

    return Column(
      children: bookings.map((b) {
        final customers =
            ref.watch(customersByBookingIdProvider(b.id)).value ?? [];
        CustomerGroup? customerGroup;
        if (b.customerGroupId != null) {
          try {
            customerGroup =
                customerGroups.firstWhere((cg) => cg.id == b.customerGroupId);
          } catch (e) {
            customerGroup = null;
          }
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => showDialog(
              context: context,
              builder: (_) => BookingEditorAlert(
                onBookingDeleted: () async =>
                    await customerRepo.deleteBooking(b.id).catchError(
                          (e) => ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(context, "Failed to delete booking."),
                          ),
                        ),
                booking: b,
                onBookingEdited: (nb) async {
                  await customerRepo.setBooking(nb);
                  ref.invalidate(bookingsByDayProvider);
                  ref.invalidate(bookingsByCustomerGroupIdProvider);
                  ref.invalidate(futureBookingsProvider);
                },
                onCustomersEdited: (ncs) async {
                  await customerRepo.setCustomers(ncs, b.id);
                  ref.invalidate(bookingsByDayProvider);
                  ref.invalidate(bookingsByCustomerGroupIdProvider);
                  ref.invalidate(futureBookingsProvider);
                },
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat("dd-MM-yyyy 'at' hh:mm").format(b.date),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      Chip(
                        avatar: Icon(
                            b.isFullyPaid
                                ? Icons.check_circle_outline_rounded
                                : Icons.error_outline_rounded,
                            size: 18),
                        label: Text(
                            b.isFullyPaid ? "Fully Paid" : "Not Fully Paid"),
                        backgroundColor: b.isFullyPaid
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                      ),
                      Chip(
                        avatar: Icon(Icons.people_outline_rounded, size: 18),
                        label: Text("${customers.length} Customers"),
                      ),
                      if (customerGroup != null)
                        Chip(
                          avatar: Icon(Icons.group_work_outlined, size: 18),
                          label: Text(customerGroup.name),
                        )
                      else
                        Chip(
                          avatar: Icon(Icons.warning_amber_rounded, size: 18),
                          label: const Text("No Customer Group"),
                          backgroundColor:
                              Theme.of(context).colorScheme.errorContainer,
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
