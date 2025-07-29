import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'riverpod.dart';

class CustomerGroupsCard extends ConsumerWidget {
  final String teamGroupId;
  const CustomerGroupsCard({super.key, required this.teamGroupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerGroups =
        ref.watch(customerGroupsForTeamgroupProvider(teamGroupId)).value ?? [];
    return Card(
      child: Text("Assigned customer groups: $customerGroups"),
    );
  }
}
