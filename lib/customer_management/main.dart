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
import 'package:mush_on/services/models/teamgroup.dart';
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
    List<Booking> futureBookings =
        ref.watch(futureBookingsProvider(untilDate: null)).value ?? [];
    List<Booking> bookingsWithoutCustomerGroup =
        futureBookings.where((b) => b.customerGroupId == null).toList();
    List<Booking> unpaidBookings =
        futureBookings.where((b) => !b.isFullyPaid).toList();
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
        Column(
          spacing: 5,
          children: [
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
            unpaidBookings.isEmpty
                ? SizedBox.shrink()
                : Column(
                    children: [
                      TextTitle("Unpaid bookings"),
                      SizedBox(
                        height: 15,
                      ),
                      ListBookings(
                          baseColor: Colors.red,
                          bookings: unpaidBookings,
                          customerGroups: futureCustomerGroups)
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
            TextTitle("Tomorrow"),
            ListCustomerGroups(
                customerGroups: ref
                        .watch(futureCustomerGroupsProvider(
                            untilDate:
                                DateTimeUtils.today().add(Duration(days: 2))))
                        .value ??
                    [],
                baseColor: Theme.of(context).colorScheme.primary),
            TextTitle("Next 7 days"),
            ListCustomerGroups(
                customerGroups: ref
                        .watch(futureCustomerGroupsProvider(
                            untilDate:
                                DateTimeUtils.today().add(Duration(days: 8))))
                        .value ??
                    [],
                baseColor: Theme.of(context).colorScheme.secondary),
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
      children: customerGroups.map(
        (cg) {
          List<Booking> bookings =
              ref.watch(bookingsByCustomerGroupIdProvider(cg.id)).value ?? [];
          TeamGroup? teamGroup;
          if (cg.teamGroupId != null) {
            teamGroup = ref.watch(teamGroupByIdProvider(cg.teamGroupId!)).value;
          }
          return InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (_) => CustomerGroupEditorAlert(
                customerGroup: cg,
                onCgEdited: (ncg) async {
                  customerRepo.setCustomerGroup(ncg);
                  ref.invalidate(customerGroupsByDayProvider);
                  ref.invalidate(futureCustomerGroupsProvider);
                  ref.invalidate(teamGroupByIdProvider);
                },
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Card.outlined(
                color: baseColor.withAlpha(75),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: baseColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "${cg.name} - ${DateFormat("dd-MM-yyyy | hh:mm").format(cg.datetime)}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Divider(
                        color: baseColor.withAlpha(200),
                      ),
                      Text("Bookings:"),
                      bookings.isEmpty
                          ? Text("No bookings assigned")
                          : Wrap(
                              children: bookings.map(
                                (b) {
                                  List<Customer> customers = ref
                                          .watch(customersByBookingIdProvider(
                                              b.id))
                                          .value ??
                                      [];
                                  String isPaidBlock = b.isFullyPaid
                                      ? "Fully paid"
                                      : "Not fully paid";
                                  return Text(
                                      "${b.name} - Customers: ${customers.length} - $isPaidBlock");
                                },
                              ).toList(),
                            ),
                      Divider(
                        color: baseColor.withAlpha(200),
                      ),
                      Text("Teamgroup assigned:"),
                      teamGroup == null
                          ? Text("No teamgroup assigned")
                          : Text(teamGroup.name)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
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
                    ref.invalidate(bookingsByCustomerGroupIdProvider);
                    ref.invalidate(futureBookingsProvider);
                  },
                  onCustomersEdited: (ncs) {
                    customerRepo.setCustomers(ncs);
                    ref.invalidate(bookingsByDayProvider);
                    ref.invalidate(bookingsByCustomerGroupIdProvider);
                    ref.invalidate(futureBookingsProvider);
                  },
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Card.outlined(
                  color: baseColor.withAlpha(75),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: baseColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "${b.name} - ${DateFormat("dd-MM-yyyy | hh:mm").format(b.date)}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
