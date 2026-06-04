import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/shared/text_title.dart';

class CustomerGroupsCard extends ConsumerWidget {
  final CustomerGroupWorkspace customerGroupWorkspace;
  final List<TourTypePricing> pricings;
  const CustomerGroupsCard({
    super.key,
    required this.customerGroupWorkspace,
    required this.pricings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          const TextTitle("Customer Group"),
          Text("Bookings: ${customerGroupWorkspace.bookings.length}"),
          Text(
            "Assigned: ${_assignedCustomers()}/${customerGroupWorkspace.customers.length}",
            style: TextStyle(
              color: _areAllAssigned() ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (pricings.isNotEmpty) ..._buildCategoryRows(),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryRows() {
    final counts = <String, ({int assigned, int total})>{};
    for (final c in customerGroupWorkspace.customers) {
      final pricing = pricings.firstWhereOrNull((p) => p.id == c.pricingId);
      final name = pricing?.name ?? "?";
      final current = counts[name] ?? (assigned: 0, total: 0);
      counts[name] = (
        assigned: current.assigned + (c.teamId != null ? 1 : 0),
        total: current.total + 1,
      );
    }
    return counts.entries.map((e) {
      final isComplete = e.value.assigned == e.value.total;
      return Text(
        "${e.key}: ${e.value.assigned}/${e.value.total}",
        style: TextStyle(color: isComplete ? Colors.green : Colors.orange),
      );
    }).toList();
  }

  int _assignedCustomers() {
    return customerGroupWorkspace.customers
        .where((c) => c.teamId != null)
        .length;
  }

  bool _areAllAssigned() {
    final int assigned = _assignedCustomers();
    final int total = customerGroupWorkspace.customers.length;
    return total == assigned;
  }
}
