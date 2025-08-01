import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/customers/customer_groups_card.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/team_builder/main.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';

class CustomersCreateTeam extends ConsumerWidget {
  final TeamGroupWorkspace teamGroup;
  const CustomersCreateTeam({super.key, required this.teamGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroup =
        ref.watch(customerAssignProvider(teamGroup.id)).value ??
            CustomerGroupWorkspace();
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomerGroupsCard(customerGroupWorkspace: customerGroup),
          ),
          ...teamGroup.teams.map(
            (team) => SingleTeamAssign(
              teamGroupId: teamGroup.id,
              team: team,
              onCustomerSelected: (customer, booking) => ref
                  .read(customerAssignProvider(teamGroup.id).notifier)
                  .editCustomer(
                    customer.copyWith(teamId: team.id),
                  ),
              onCustomerDeselected: (customer, booking) => ref
                  .read(customerAssignProvider(teamGroup.id).notifier)
                  .editCustomer(
                    customer.copyWith(teamId: null),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class SingleTeamAssign extends ConsumerWidget {
  final TeamWorkspace team;
  final String teamGroupId;
  final Function(Customer, Booking) onCustomerSelected;
  final Function(Customer, Booking) onCustomerDeselected;
  const SingleTeamAssign(
      {super.key,
      required this.team,
      required this.onCustomerSelected,
      required this.onCustomerDeselected,
      required this.teamGroupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroup =
        ref.watch(customerAssignProvider(teamGroupId)).value ??
            CustomerGroupWorkspace();
    List<Dog> allDogs = ref.watch(dogsProvider).value ?? [];
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            Text(
              "Team: ${CreateTeamsString(allDogs: allDogs).stringifyTeam(team).trim()}",
            ),
            Text(
                "Customers assigned: ${customerGroup.customers.where((c) => c.teamId == team.id).length}"),
            Text(_displayCustomerNames(customerGroup.customers
                .where((c) => c.teamId == team.id)
                .toList())),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AssignCustomersAlert(
                    team: team,
                    teamGroupId: teamGroupId,
                    onCustomerSelected: (customer, booking) =>
                        onCustomerSelected(customer, booking),
                    onCustomerDeselected: (customer, booking) =>
                        onCustomerDeselected(customer, booking),
                  ),
                );
              },
              child: Text("Assign customers"),
            ),
          ],
        ),
      ),
    );
  }

  String _displayCustomerNames(List<Customer> customers) {
    List<String> cc = [];
    for (Customer customer in customers) {
      cc.add(customer.name);
    }
    return cc.join(" - ");
  }
}

class AssignCustomersAlert extends ConsumerWidget {
  final TeamWorkspace team;
  final String teamGroupId;
  final Function(Customer, Booking) onCustomerSelected;
  final Function(Customer, Booking) onCustomerDeselected;
  const AssignCustomersAlert(
      {super.key,
      required this.team,
      required this.teamGroupId,
      required this.onCustomerSelected,
      required this.onCustomerDeselected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroup =
        ref.watch(customerAssignProvider(teamGroupId)).value ??
            CustomerGroupWorkspace();
    return AlertDialog.adaptive(
      insetPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      contentPadding: EdgeInsets.all(10),
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Assign customers"),
          Tooltip(
            showDuration: Duration(seconds: 5),
            triggerMode: TooltipTriggerMode.tap,
            message:
                "Assign customers to this sled.\nGreen: assigned to this sled.\nBlue: available.\nGrey: Assigned to another sled.",
            child: Icon(Icons.question_mark),
          ),
        ],
      ),
      content: Column(
        children: [
          Text("Assign customers to team: ${team.name}"),
          ...customerGroup.bookings.map(
            (booking) => BookingDisplay(
              booking: booking,
              teamId: team.id,
              teamGroupId: teamGroupId,
              onCustomerSelected: (customer) =>
                  onCustomerSelected(customer, booking),
              onCustomerDeselected: (customer) =>
                  onCustomerDeselected(customer, booking),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(), child: Text("Close"))
      ],
    );
  }
}

class BookingDisplay extends ConsumerWidget {
  final Booking booking;
  final String teamId;
  final String teamGroupId;
  final Function(Customer) onCustomerSelected;
  final Function(Customer) onCustomerDeselected;
  const BookingDisplay(
      {super.key,
      required this.booking,
      required this.teamId,
      required this.teamGroupId,
      required this.onCustomerSelected,
      required this.onCustomerDeselected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroup =
        ref.watch(customerAssignProvider(teamGroupId)).value ??
            CustomerGroupWorkspace();
    var customers = _sortCustomers(customerGroup.customers, teamId);
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              Text("Booking: ${booking.name}"),
              Wrap(
                spacing: 10,
                children: customers
                    .where((customer) => customer.bookingId == booking.id)
                    .map(
                      (c) => CustomerActionChip(
                        customer: c,
                        teamId: teamId,
                        onCustomerSelected: () => onCustomerSelected(c),
                        onCustomerDeselected: () => onCustomerDeselected(c),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sort customers with available on top, then available, then unavailable. Finally, by name.
  List<Customer> _sortCustomers(List<Customer> customers, String teamId) {
    List<Customer> toReturn = [];

    List<Customer> selectedCustomers =
        customers.where((c) => c.teamId != null && c.teamId == teamId).toList();
    selectedCustomers.sort((a, b) => a.name.compareTo(b.name));
    toReturn.addAll(selectedCustomers);

    List<Customer> availableCustomers =
        customers.where((c) => c.teamId == null).toList();
    availableCustomers.sort((a, b) => a.name.compareTo(b.name));
    toReturn.addAll(availableCustomers);

    List<Customer> unavailableCustomers =
        customers.where((c) => c.teamId != null && c.teamId != teamId).toList();
    unavailableCustomers.sort((a, b) => a.name.compareTo(b.name));
    toReturn.addAll(unavailableCustomers);

    return toReturn;
  }
}

class CustomerActionChip extends ConsumerWidget {
  final Customer customer;
  final String teamId;
  final Function() onCustomerSelected;
  final Function() onCustomerDeselected;
  const CustomerActionChip(
      {super.key,
      required this.customer,
      required this.teamId,
      required this.onCustomerSelected,
      required this.onCustomerDeselected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => onCustomerSelected(),
      child: Card(
        color: _getBackgroundColor(),
        child: IntrinsicWidth(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(customer.name),
                  ],
                ),
                IconButton(
                  onPressed: () => onCustomerDeselected(),
                  icon: Icon(Icons.cancel_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (customer.teamId == null) {
      return Colors.blue;
    } else if (customer.teamId != teamId) {
      return Colors.grey;
    } else {
      return Colors.green;
    }
  }
}
