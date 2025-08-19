import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/alert_editors/booking.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:intl/intl.dart';

import '../create_team/riverpod.dart';
import '../riverpod.dart';
import 'alert_editors/customer_group.dart';
import 'repository.dart';
import 'riverpod.dart';
import 'tours/models.dart';
import 'tours/riverpod.dart';

class CustomerGroupViewerScreen extends StatelessWidget {
  final String customerGroupId;
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
  final String customerGroupId;
  const CustomerGroupViewer({super.key, required this.customerGroupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value ?? "";
    final customerGroupAsync = ref.watch(
      CustomerGroupByIdProvider(customerGroupId),
    );
    final List<Booking> bookings =
        ref.watch(bookingsByCustomerGroupIdProvider(customerGroupId)).value ??
            [];
    final List<Customer> customers =
        ref.watch(CustomersByCustomerGroupIdProvider(customerGroupId)).value ??
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
          tour =
              ref.watch(tourTypeByIdProvider(customerGroup.tourTypeId!)).value;
        }
        List<TourTypePricing>? pricings;
        if (tour != null) {
          pricings = ref.watch(tourTypePricesProvider(tour.id)).value;
        }
        final customerRepo = CustomerManagementRepository(account: account);
        final colorScheme = Theme.of(context).colorScheme;
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
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimaryContainer,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => CustomerGroupEditorAlert(
                            onCustomerGroupDeleted: () => customerRepo
                                .deleteCustomerGroup(customerGroup.id)
                                .catchError(
                              (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    errorSnackBar(context,
                                        "Failed to delete customer group."),
                                  );
                                }
                              },
                            ),
                            customerGroup: customerGroup,
                            onCgEdited: (ncg) async {
                              customerRepo.setCustomerGroup(ncg);
                              ref.invalidate(customerGroupsByDayProvider);
                              ref.invalidate(futureCustomerGroupsProvider);
                              ref.invalidate(teamGroupByIdProvider);
                            },
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
                ),
              ),
              const SizedBox(height: 16),

              // Overview
              Card(
                elevation: 0,
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Date & Time
                      Row(
                        children: [
                          Icon(Icons.event,
                              color: colorScheme.onSurfaceVariant, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat("EEEE, MMMM d, yyyy")
                                .format(customerGroup.datetime),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              color: colorScheme.onSurfaceVariant, size: 20),
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
                          Icon(Icons.people,
                              color: colorScheme.onSurfaceVariant, size: 20),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
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
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.straighten,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20),
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
                                Icon(Icons.schedule,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20),
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
                                  Icon(Icons.notes,
                                      color: colorScheme.onSurfaceVariant,
                                      size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      tour.notes!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
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
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.event_busy,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 8),
                            Text(
                              "No bookings for this group",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
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
                          color: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.event, color: colorScheme.primary),
                                const SizedBox(width: 8),
                                Text(
                                  "Bookings (${bookings.length})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...bookings.map(
                          (booking) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: BookingCard(
                              selectedCustomerGroup: customerGroup,
                              pricings: pricings,
                              booking: booking,
                              customers: ref
                                      .watch(customersByBookingIdProvider(
                                          booking.id))
                                      .value ??
                                  [],
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
      error: (e, s) {
        BasicLogger().error("Error loading customer group: $customerGroupId",
            error: e, stackTrace: s);
        return const Center(child: Text("Error: couldn't load the customer group."));
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

class BookingCard extends ConsumerWidget {
  final Booking booking;
  final List<Customer> customers;
  final List<TourTypePricing>? pricings;
  final CustomerGroup selectedCustomerGroup;
  const BookingCard(
      {super.key,
      required this.booking,
      required this.customers,
      required this.pricings,
      required this.selectedCustomerGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (_) => BookingEditorAlert(
          selectedCustomerGroup: selectedCustomerGroup,
          onBookingDeleted: () async {
            final String account = await ref.watch(accountProvider.future);
            final customerRepo = CustomerManagementRepository(account: account);
            return await customerRepo.deleteBooking(booking.id).catchError(
                  (e) => ScaffoldMessenger.of(context).showSnackBar(
                    errorSnackBar(context, "Failed to delete booking."),
                  ),
                );
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
        color: colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bookmark,
                      color: colorScheme.onSecondaryContainer, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSecondaryContainer,
                          ),
                    ),
                  ),
                  Icon(Icons.edit,
                      color: colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.7),
                      size: 16),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.people_outline,
                      color: colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.8),
                      size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "People: ${customers.length}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                  ),
                ],
              ),
              if (pricings != null) ...[
                const SizedBox(height: 8),
                getPricings(customers, pricings!),
              ],
            ],
          ),
        ),
      ),
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
        Builder(builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(Icons.local_offer,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 16),
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
        }),
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
