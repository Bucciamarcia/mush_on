import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';

class CustomerGroupsCard extends ConsumerWidget {
  final List<CustomerGroup> customerGroups;
  const CustomerGroupsCard({super.key, required this.customerGroups});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Text("Assigned customer groups: $customerGroups"),
    );
  }
}
