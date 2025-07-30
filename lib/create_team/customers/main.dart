import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/customers/customer_groups_card.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/team_builder/main.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';

class CustomersCreateTeam extends ConsumerWidget {
  final CustomerGroupWorkspace customerGroupWorkspace;
  final TeamGroupWorkspace teamGroup;
  const CustomersCreateTeam(
      {super.key,
      required this.customerGroupWorkspace,
      required this.teamGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomerGroupsCard(
                customerGroupWorkspace: customerGroupWorkspace),
          ),
          ...teamGroup.teams.map(
            (team) => SingleTeamAssign(
              team: team,
              customerGroup: customerGroupWorkspace,
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
  final CustomerGroupWorkspace customerGroup;
  final Function(Customer, Booking) onCustomerSelected;
  final Function(Customer, Booking) onCustomerDeselected;
  const SingleTeamAssign(
      {super.key,
      required this.team,
      required this.customerGroup,
      required this.onCustomerSelected,
      required this.onCustomerDeselected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Dog> allDogs = ref.watch(dogsProvider).value ?? [];
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            Text(
              "Team: ${CreateTeamsString(allDogs: allDogs).stringifyTeam(team).trim()}",
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AssignCustomersAlert(
                    team: team,
                    customerGroup: customerGroup,
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
}

class AssignCustomersAlert extends StatelessWidget {
  final TeamWorkspace team;
  final CustomerGroupWorkspace customerGroup;
  final Function(Customer, Booking) onCustomerSelected;
  final Function(Customer, Booking) onCustomerDeselected;
  const AssignCustomersAlert(
      {super.key,
      required this.team,
      required this.customerGroup,
      required this.onCustomerSelected,
      required this.onCustomerDeselected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text("Assign customers"),
      content: Column(
        children: [
          Text("Assign customers to team: ${team.name}"),
          ...customerGroup.bookings.map(
            (booking) => BookingDisplay(
              booking: booking,
              customers: customerGroup.customers,
              onCustomerSelected: (customer) =>
                  onCustomerSelected(customer, booking),
              onCustomerDeselected: (customer) =>
                  onCustomerDeselected(customer, booking),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingDisplay extends StatelessWidget {
  final Booking booking;
  final List<Customer> customers;
  final Function(Customer) onCustomerSelected;
  final Function(Customer) onCustomerDeselected;
  const BookingDisplay(
      {super.key,
      required this.booking,
      required this.customers,
      required this.onCustomerSelected,
      required this.onCustomerDeselected});

  @override
  Widget build(BuildContext context) {
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
}

class CustomerActionChip extends ConsumerWidget {
  final Customer customer;
  final Function() onCustomerSelected;
  final Function() onCustomerDeselected;
  const CustomerActionChip(
      {super.key,
      required this.customer,
      required this.onCustomerSelected,
      required this.onCustomerDeselected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputChip(
      label: Text(customer.name),
      backgroundColor: customer.teamId == null || customer.teamId!.isEmpty
          ? Colors.red
          : Colors.green,
      onPressed: () => onCustomerSelected(),
      onDeleted: () => onCustomerDeselected(),
      deleteIcon: Icon(Icons.cancel),
    );
  }
}
