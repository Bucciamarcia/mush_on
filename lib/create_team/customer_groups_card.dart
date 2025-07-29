import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/riverpod.dart';

class CustomerGroupsCard extends ConsumerWidget {
  final CustomerGroupWorkspace customerGroupWorkspace;
  const CustomerGroupsCard({super.key, required this.customerGroupWorkspace});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          Text(
            "Customer groups: ${customerGroupWorkspace.customerGroups.length}",
          ),
          Text(
            "Bookings: ${customerGroupWorkspace.bookings.length}",
          ),
          Text(
            "Customers: ${customerGroupWorkspace.customers.length}",
          ),
        ],
      ),
    );
  }
}
