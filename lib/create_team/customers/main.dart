import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/customers/customer_groups_card.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/create_team/team_builder/main.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:uuid/uuid.dart';

String _customerLabel(
  Customer customer,
  List<Customer> allCustomers,
  List<TourTypePricing> pricings,
) {
  final pricing = pricings.firstWhereOrNull((p) => p.id == customer.pricingId);
  final pricingName = pricing?.name ?? "customer";
  final sameCategory = allCustomers
      .where(
        (c) =>
            c.bookingId == customer.bookingId &&
            c.pricingId == customer.pricingId,
      )
      .toList()
    ..sort((a, b) => a.id.compareTo(b.id));
  final index = sameCategory.indexWhere((c) => c.id == customer.id);
  return "$pricingName - ${index + 1}";
}

String _categorySummary(
  List<Customer> customers,
  List<TourTypePricing> pricings,
) {
  final counts = <String, int>{};
  for (final c in customers) {
    final pricing = pricings.firstWhereOrNull((p) => p.id == c.pricingId);
    final name = pricing?.name ?? "?";
    counts[name] = (counts[name] ?? 0) + 1;
  }
  if (counts.isEmpty) return "";
  return counts.entries.map((e) => "${e.value} ${e.key}").join(" · ");
}

class CustomersCreateTeam extends ConsumerWidget {
  static final BasicLogger logger = BasicLogger();
  final TeamGroupWorkspace teamGroup;
  const CustomersCreateTeam({super.key, required this.teamGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroup = ref.watch(customerAssignProvider(teamGroup.id)).value;
    if (customerGroup == null) {
      return const SingleChildScrollView(
        child: Column(
          spacing: 20,
          children: [TextTitle("No customer group assigned")],
        ),
      );
    }
    final tourTypeId = customerGroup.customerGroup.tourTypeId;
    final pricings = tourTypeId != null
        ? ref
                  .watch(tourTypePricesProvider(tourTypeId, getArchived: true))
                  .value ??
              []
        : <TourTypePricing>[];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomerGroupsCard(
              customerGroupWorkspace: customerGroup,
              pricings: pricings,
            ),
          ),
          ...teamGroup.teams.map(
            (team) => SingleTeamAssign(
              teamGroupId: teamGroup.id,
              team: team,
              pricings: pricings,
              onCustomerSelected: (customer, booking) => ref
                  .read(customerAssignProvider(teamGroup.id).notifier)
                  .editCustomer(customer.copyWith(teamId: team.id)),
              onCustomerDeselected: (customer, booking) => ref
                  .read(customerAssignProvider(teamGroup.id).notifier)
                  .editCustomer(customer.copyWith(teamId: null)),
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
  final List<TourTypePricing> pricings;
  final Function(Customer, Booking) onCustomerSelected;
  final Function(Customer, Booking) onCustomerDeselected;
  const SingleTeamAssign({
    super.key,
    required this.team,
    required this.onCustomerSelected,
    required this.onCustomerDeselected,
    required this.teamGroupId,
    required this.pricings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroup =
        ref.watch(customerAssignProvider(teamGroupId)).value ??
        CustomerGroupWorkspace(
          customerGroup: CustomerGroup(
            tourTypeId: "",
            id: const Uuid().v4(),
            datetime: DateTime.now(),
          ),
        );
    List<Dog> allDogs = ref.watch(dogsProvider).value ?? [];
    final assignedCustomers = customerGroup.customers
        .where((c) => c.teamId == team.id)
        .toList();
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            Text(
              "Team: ${CreateTeamsString(allDogs: allDogs).stringifyTeam(team).trim()}",
            ),
            Text(
              "Sled capacity: ${assignedCustomers.length} / ${team.capacity}",
              style: TextStyle(color: _buildTeamColor(customerGroup, team)),
            ),
            if (assignedCustomers.isNotEmpty)
              Text(_categorySummary(assignedCustomers, pricings)),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AssignCustomersAlert(
                    team: team,
                    teamGroupId: teamGroupId,
                    pricings: pricings,
                    onCustomerSelected: (customer, booking) =>
                        onCustomerSelected(customer, booking),
                    onCustomerDeselected: (customer, booking) =>
                        onCustomerDeselected(customer, booking),
                  ),
                );
              },
              child: const Text("Assign customers"),
            ),
          ],
        ),
      ),
    );
  }

  Color _buildTeamColor(
    CustomerGroupWorkspace? customerGroup,
    TeamWorkspace team,
  ) {
    int assigned =
        customerGroup?.customers.where((c) => c.teamId == team.id).length ?? 0;
    int capacity = team.capacity;
    if (assigned == capacity) {
      return Colors.green;
    } else if (assigned > capacity) {
      return Colors.red;
    } else if (assigned < capacity) {
      return Colors.orange;
    }
    return Colors.black;
  }
}

class AssignCustomersAlert extends ConsumerWidget {
  final TeamWorkspace team;
  final String teamGroupId;
  final List<TourTypePricing> pricings;
  final Function(Customer, Booking) onCustomerSelected;
  final Function(Customer, Booking) onCustomerDeselected;
  const AssignCustomersAlert({
    super.key,
    required this.team,
    required this.teamGroupId,
    required this.pricings,
    required this.onCustomerSelected,
    required this.onCustomerDeselected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroup =
        ref.watch(customerAssignProvider(teamGroupId)).value ??
        CustomerGroupWorkspace(
          customerGroup: CustomerGroup(
            tourTypeId: "",
            id: const Uuid().v4(),
            datetime: DateTime.now(),
          ),
        );
    return AlertDialog.adaptive(
      insetPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      contentPadding: const EdgeInsets.all(10),
      scrollable: true,
      title: const Row(
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
              pricings: pricings,
              allCustomers: customerGroup.customers,
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}

class BookingDisplay extends ConsumerWidget {
  final Booking booking;
  final String teamId;
  final String teamGroupId;
  final List<TourTypePricing> pricings;
  final List<Customer> allCustomers;
  final Function(Customer) onCustomerSelected;
  final Function(Customer) onCustomerDeselected;
  const BookingDisplay({
    super.key,
    required this.booking,
    required this.teamId,
    required this.teamGroupId,
    required this.pricings,
    required this.allCustomers,
    required this.onCustomerSelected,
    required this.onCustomerDeselected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroup =
        ref.watch(customerAssignProvider(teamGroupId)).value ??
        CustomerGroupWorkspace(
          customerGroup: CustomerGroup(
            tourTypeId: "",
            id: const Uuid().v4(),
            datetime: DateTime.now(),
          ),
        );
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
                        booking: booking,
                        pricings: pricings,
                        allCustomers: allCustomers,
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

  List<Customer> _sortCustomers(List<Customer> customers, String teamId) {
    List<Customer> toReturn = [];

    List<Customer> selectedCustomers = customers
        .where((c) => c.teamId != null && c.teamId == teamId)
        .toList();
    selectedCustomers.sort((a, b) => a.id.compareTo(b.id));
    toReturn.addAll(selectedCustomers);

    List<Customer> availableCustomers = customers
        .where((c) => c.teamId == null)
        .toList();
    availableCustomers.sort((a, b) => a.id.compareTo(b.id));
    toReturn.addAll(availableCustomers);

    List<Customer> unavailableCustomers = customers
        .where((c) => c.teamId != null && c.teamId != teamId)
        .toList();
    unavailableCustomers.sort((a, b) => a.id.compareTo(b.id));
    toReturn.addAll(unavailableCustomers);

    return toReturn;
  }
}

class CustomerActionChip extends ConsumerWidget {
  final Customer customer;
  final String teamId;
  final Booking booking;
  final List<TourTypePricing> pricings;
  final List<Customer> allCustomers;
  final Function() onCustomerSelected;
  final Function() onCustomerDeselected;
  const CustomerActionChip({
    super.key,
    required this.customer,
    required this.teamId,
    required this.booking,
    required this.pricings,
    required this.allCustomers,
    required this.onCustomerSelected,
    required this.onCustomerDeselected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAvailable = customer.teamId == null;
    final isOnThisSled = customer.teamId == teamId;
    final isOnAnotherSled = customer.teamId != null && !isOnThisSled;
    final label = _customerLabel(customer, allCustomers, pricings);
    final bookingSubtitle = _bookingSubtitle();

    return InkWell(
      onTap: isAvailable ? () => onCustomerSelected() : null,
      child: Card(
        color: _getBackgroundColor(),
        child: IntrinsicWidth(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label),
                    if (bookingSubtitle.isNotEmpty)
                      Text(
                        bookingSubtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    Text(
                      _getStatusLabel(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _showBookingInfo(context, label),
                  icon: const Icon(Icons.info_outline, size: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: const BoxConstraints(),
                ),
                if (isOnThisSled)
                  IconButton(
                    onPressed: () => onCustomerDeselected(),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                if (isOnAnotherSled)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: OutlinedButton(
                      onPressed: () => _confirmMove(context, label),
                      child: const Text("Move here"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _bookingSubtitle() {
    if (booking.name.isNotEmpty) return booking.name;
    if (booking.email != null && booking.email!.isNotEmpty) {
      return booking.email!;
    }
    if (booking.phone != null && booking.phone!.isNotEmpty) {
      return booking.phone!;
    }
    return "";
  }

  void _showBookingInfo(BuildContext context, String customerLabel) {
    final bookingCustomers = allCustomers
        .where((c) => c.bookingId == booking.id)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          booking.name.isNotEmpty ? booking.name : "Booking info",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (booking.email != null && booking.email!.isNotEmpty)
              Text("Email: ${booking.email}"),
            if (booking.phone != null && booking.phone!.isNotEmpty)
              Text("Phone: ${booking.phone}"),
            const SizedBox(height: 8),
            Text(
              "Customers in this booking:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            ...bookingCustomers.map((c) {
              final lbl = _customerLabel(c, allCustomers, pricings);
              final status = c.teamId == null
                  ? "unassigned"
                  : c.teamId == teamId
                  ? "this sled"
                  : "another sled";
              return Text("$lbl — $status");
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmMove(BuildContext context, String label) async {
    final shouldMove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Move customer?"),
        content: Text("Move $label to this sled?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Move here"),
          ),
        ],
      ),
    );
    if (shouldMove == true) {
      onCustomerSelected();
    }
  }

  String _getStatusLabel() {
    if (customer.teamId == null) {
      return "Available";
    } else if (customer.teamId != teamId) {
      return "On another sled";
    } else {
      return "On this sled";
    }
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
