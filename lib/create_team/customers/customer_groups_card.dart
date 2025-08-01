import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/shared/text_title.dart';

class CustomerGroupsCard extends ConsumerWidget {
  final CustomerGroupWorkspace customerGroupWorkspace;
  const CustomerGroupsCard({super.key, required this.customerGroupWorkspace});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          TextTitle("Customer Group"),
          Text(
            "Bookings: ${customerGroupWorkspace.bookings.length}",
          ),
          Text(
            "Customers: ${customerGroupWorkspace.customers.length}",
          ),
          Text(
            "Assigned customers: ${_assignedCustomers()}/${customerGroupWorkspace.customers.length}",
            style: TextStyle(
              color: _areAllAssigned() ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  int _assignedCustomers() {
    return customerGroupWorkspace.customers
        .where((c) => c.teamId != null)
        .length;
  }

  bool _areAllAssigned() {
    final int assigned = _assignedCustomers();
    final int total = customerGroupWorkspace.customers.length;
    if (total == assigned) {
      return true;
    } else {
      return false;
    }
  }
}
