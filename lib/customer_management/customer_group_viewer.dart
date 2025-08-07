import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/alert_editors/booking.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/error_handling.dart';

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
          return Text("Couldn't load teamgroup: null");
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
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text(
                  customerGroup.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => CustomerGroupEditorAlert(
                      onCustomerGroupDeleted: () => customerRepo
                          .deleteCustomerGroup(customerGroup.id)
                          .catchError(
                        (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(
                                  context, "Failed to delete customer group."),
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
                  child: Text("Edit Customer Group"),
                ),
                Divider(),

                // Overview
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      children: [
                        Text(
                          "Overview",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                            "Customers: ${customers.length}/${customerGroup.maxCapacity}"),
                        pricings != null
                            ? getPricings(customers, pricings)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),

                // Tour
                tour == null
                    ? Text(
                        "No tour selected.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Column(
                            children: [
                              Text(
                                "Tour: ${tour.name}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                              Text("Distance: ${tour.distance}"),
                              Text("Duration: ${tour.duration}"),
                              Text("${tour.notes}", maxLines: 5),
                            ],
                          ),
                        ),
                      ),

                // Bookings
                bookings.isEmpty
                    ? Text(
                        "No bookings for this group",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Card(
                          child: Column(
                            children: [
                              Text(
                                "Bookings",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                              ...bookings.map(
                                (booking) => BookingCard(
                                  pricings: pricings,
                                  booking: booking,
                                  customers: ref
                                          .watch(customersByBookingIdProvider(
                                              booking.id))
                                          .value ??
                                      [],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
      error: (e, s) {
        BasicLogger().error("Error loading customer group: $customerGroupId",
            error: e, stackTrace: s);
        return Center(child: Text("Error: couldn't load the customer group."));
      },
      loading: () => Center(
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
  const BookingCard(
      {super.key,
      required this.booking,
      required this.customers,
      required this.pricings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (_) => BookingEditorAlert(
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
            ref.invalidate(bookingsByDayProvider);
            ref.invalidate(bookingsByCustomerGroupIdProvider);
            ref.invalidate(futureBookingsProvider);
          },
          onCustomersEdited: (ncs) async {
            final String account = await ref.watch(accountProvider.future);
            final customerRepo = CustomerManagementRepository(account: account);
            await customerRepo.setCustomers(ncs, booking.id);
            ref.invalidate(bookingsByDayProvider);
            ref.invalidate(bookingsByCustomerGroupIdProvider);
            ref.invalidate(futureBookingsProvider);
          },
        ),
      ),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Column(
          children: [
            Text(booking.name),
            Text("People: ${customers.length}"),
            Text("Details:"),
            pricings == null
                ? SizedBox.shrink()
                : getPricings(customers, pricings!),
          ],
        ),
      ),
    );
  }
}

Widget getPricings(List<Customer> customers, List<TourTypePricing> pricings) {
  String toReturn = "";
  for (var price in pricings) {
    List<Customer> customerWithPrice = customers
        .where((c) => c.pricingId != null && c.pricingId == price.id)
        .toList();
    if (customerWithPrice.isNotEmpty) {
      toReturn = "$toReturn\n${price.name}: ${customerWithPrice.length}";
    }
  }
  toReturn = toReturn.trim();
  if (toReturn.isEmpty) {
    return SizedBox.shrink();
  }
  return Text(toReturn);
}
