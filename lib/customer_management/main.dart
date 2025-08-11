import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/customer_management/alert_editors/booking.dart';
import 'package:mush_on/customer_management/calendar/main.dart';
import 'package:mush_on/customer_management/repository.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'customer_group_viewer.dart';
import 'models.dart';

class ClientManagementMainScreen extends ConsumerWidget {
  static final logger = BasicLogger();
  const ClientManagementMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysCustomerGroups =
        ref.watch(customerGroupsByDayProvider(DateTimeUtils.today())).value ??
            [];
    final todaysOrphanedCustomerGroups =
        todaysCustomerGroups.where((cg) => cg.teamGroupId == null).toList();
    final futureCustomerGroups =
        ref.watch(futureCustomerGroupsProvider(untilDate: null)).value ?? [];
    final customerGroupsWithoutTeamgroup =
        futureCustomerGroups.where((c) => c.teamGroupId == null).toList();

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
      if (customerGroupsWithoutTeamgroup.isNotEmpty)
        _WarningSection(
          title: "Future Customer Groups Without a Team",
          child: ListCustomerGroups(
              customerGroups: customerGroupsWithoutTeamgroup),
        ),
    ];
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                child: Text("Overview"),
              ),
              Tab(
                child: Text("Calendar"),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
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

                      // Future
                      _buildSectionTitle(context, "Upcoming"),
                      _buildExpansionTileChild(
                        context,
                        "Tomorrow",
                        tomorrowCustomerGroups.isNotEmpty
                            ? ListCustomerGroups(
                                customerGroups: tomorrowCustomerGroups)
                            : const Text("No customer groups for tomorrow."),
                      ),
                      _buildExpansionTileChild(
                        context,
                        "Next 7 Days",
                        next7DaysCustomerGroups.isNotEmpty
                            ? ListCustomerGroups(
                                customerGroups: next7DaysCustomerGroups)
                            : const Text(
                                "No customer groups for the next 7 days."),
                      ),
                    ],
                  ),
                ),
                BookingCalendar(),
              ],
            ),
          ),
        ],
      ),
    );
    // Data fetching remains the same
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
    return Column(
      children: customerGroups.map(
        (cg) {
          final bookings =
              ref.watch(bookingsByCustomerGroupIdProvider(cg.id)).value ?? [];
          final teamGroup = (cg.teamGroupId != null)
              ? ref.watch(teamGroupByIdProvider(cg.teamGroupId!)).value
              : null;

          final customers =
              ref.watch(customersByCustomerGroupIdProvider(cg.id)).value ?? [];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CustomerGroupViewerScreen(customerGroupId: cg.id),
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
                    Row(
                      children: [
                        Icon(Icons.people,
                            size: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "${customers.length}/${cg.maxCapacity}",
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
                      ...bookings.map((b) => _BookingCardInGroup(
                            booking: b,
                            selectedCustomerGroup: cg,
                          )),
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
  final CustomerGroup selectedCustomerGroup;

  const _BookingCardInGroup(
      {required this.booking, required this.selectedCustomerGroup});

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
            selectedCustomerGroup: selectedCustomerGroup,
            booking: booking,
            onBookingDeleted: () async =>
                await customerRepo.deleteBooking(booking.id).catchError(
                      (e) => ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(context, "Failed to delete booking."),
                      ),
                    ),
            onBookingEdited: (nb) async {
              await customerRepo.setBooking(nb);
              ref.invalidate(bookingsByCustomerGroupIdProvider);
            },
            onCustomersEdited: (ncs) async {
              await customerRepo.setCustomers(ncs, booking.id);
              ref.invalidate(bookingsByCustomerGroupIdProvider);
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
