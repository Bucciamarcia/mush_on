import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/alert_editors/booking.dart';
import 'package:mush_on/customer_management/alert_editors/customer_group.dart';
import 'package:mush_on/customer_management/repository.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/shared/text_title.dart';
import 'models.dart';

class ClientManagementMainScreen extends ConsumerWidget {
  static final logger = BasicLogger();
  const ClientManagementMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CustomerGroup> todaysCustomerGroups =
        ref.watch(customerGroupsByDayProvider(DateTimeUtils.today())).value ??
            [];
    List<CustomerGroup> todaysOrphanedCustomerGroups =
        todaysCustomerGroups.where((cg) => cg.teamGroupId == null).toList();
    List<Booking> todaysBookings =
        ref.watch(bookingsByDayProvider(DateTimeUtils.today())).value ?? [];
    List<Booking> todaysOrphanedBookings =
        todaysBookings.where((b) => b.customerGroupId == null).toList();
    double todaysRevenue = 0;
    for (Booking b in todaysBookings) {
      todaysRevenue = todaysRevenue += b.price;
    }
    List<Booking> bookingsWithoutCustomerGroup =
        ref.watch(futureBookingsProvider(untilDate: null)).value ?? [];
    bookingsWithoutCustomerGroup = bookingsWithoutCustomerGroup
        .where((b) => b.customerGroupId == null)
        .toList();
    List<CustomerGroup> futureCustomerGroups =
        ref.watch(futureCustomerGroupsProvider(untilDate: null)).value ?? [];
    List<CustomerGroup> customerGroupsWithoutTeamgroup =
        futureCustomerGroups.where((c) => c.teamGroupId == null).toList();

    return ListView(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: TextTitle("Today's overview"),
        ),
        SizedBox(height: 15),
        Wrap(
          spacing: 5,
          children: [
            Text("Today's revenue: $todaysRevenue"),
            todaysOrphanedCustomerGroups.isEmpty
                ? SizedBox.shrink()
                : Column(
                    children: [
                      TextTitle("Orphaned customer groups"),
                      SizedBox(height: 15),
                      ListCustomerGroups(
                          customerGroups: todaysOrphanedCustomerGroups,
                          baseColor: Colors.red),
                    ],
                  ),
            todaysOrphanedBookings.isEmpty
                ? SizedBox.shrink()
                : Column(
                    children: [
                      TextTitle("Orhpaned bookings"),
                      SizedBox(
                        height: 15,
                      ),
                      ListBookings(
                          baseColor: Colors.red,
                          bookings: todaysOrphanedBookings,
                          customerGroups: todaysCustomerGroups)
                    ],
                  ),
            TextTitle("Today's customer groups"),
            ListCustomerGroups(
                customerGroups: todaysCustomerGroups, baseColor: Colors.green),
            TextTitle("Today's bookings"),
            ListBookings(
              baseColor: Colors.greenAccent,
              bookings: todaysBookings,
              customerGroups: todaysCustomerGroups,
            ),
            TextTitle("Customer groups without teamgroup"),
            ListCustomerGroups(
              customerGroups: customerGroupsWithoutTeamgroup,
              baseColor: Colors.red,
            ),
            TextTitle("Bookings without customer group"),
            ListBookings(
              baseColor: Colors.red,
              bookings: bookingsWithoutCustomerGroup,
              customerGroups: futureCustomerGroups,
            ),
          ],
        ),
      ],
    );
  }
}

/// A list of the customer groups that can be clicked. In Column() form.
class ListCustomerGroups extends ConsumerWidget {
  final List<CustomerGroup> customerGroups;
  final Color baseColor;
  const ListCustomerGroups(
      {super.key, required this.customerGroups, required this.baseColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);
    return Column(
      spacing: 15,
      children: customerGroups
          .map(
            (cg) => InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => CustomerGroupEditorAlert(
                  customerGroup: cg,
                  onCgEdited: (ncg) {
                    customerRepo.setCustomerGroup(ncg);
                    ref.invalidate(customerGroupsByDayProvider);
                    ref.invalidate(
                        futureCustomerGroupsProvider(untilDate: null));
                  },
                ),
              ),
              child: Card(
                color: baseColor.withAlpha(150),
                child: Text(cg.name),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// A list of the bookings that can be clicked. In Column() form.
class ListBookings extends ConsumerWidget {
  final List<Booking> bookings;
  final List<CustomerGroup> customerGroups;
  final Color baseColor;
  const ListBookings(
      {super.key,
      required this.baseColor,
      required this.bookings,
      required this.customerGroups});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);
    return Column(
      spacing: 15,
      children: bookings
          .map(
            (b) => InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => BookingEditorAlert(
                  booking: b,
                  onBookingEdited: (nb) {
                    customerRepo.setBooking(nb);
                    ref.invalidate(bookingsByDayProvider);
                    ref.invalidate(futureBookingsProvider);
                  },
                  onCustomersEdited: (ncs) {
                    customerRepo.setCustomers(ncs);
                    ref.invalidate(bookingsByDayProvider);
                    ref.invalidate(futureBookingsProvider);
                  },
                ),
              ),
              child: Card(
                color: baseColor.withAlpha(150),
                child: Text(b.name),
              ),
            ),
          )
          .toList(),
    );
  }
}
