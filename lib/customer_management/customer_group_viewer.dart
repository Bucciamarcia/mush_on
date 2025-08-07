import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/error_handling.dart';

import '../create_team/riverpod.dart';
import '../riverpod.dart';
import 'alert_editors/customer_group.dart';
import 'repository.dart';
import 'riverpod.dart';

class CustomerGroupViewerScreen extends StatelessWidget {
  final CustomerGroup customerGroup;
  const CustomerGroupViewerScreen({super.key, required this.customerGroup});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
      title: "View customer group",
      child: CustomerGroupViewer(customerGroup: customerGroup),
    );
  }
}

class CustomerGroupViewer extends ConsumerWidget {
  final CustomerGroup customerGroup;
  const CustomerGroupViewer({super.key, required this.customerGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => CustomerGroupEditorAlert(
          onCustomerGroupDeleted: () => customerRepo
              .deleteCustomerGroup(customerGroup.id)
              .catchError(
                (e) => ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar(context, "Failed to delete customer group."),
                ),
              ),
          customerGroup: customerGroup,
          onCgEdited: (ncg) async {
            customerRepo.setCustomerGroup(ncg);
            ref.invalidate(customerGroupsByDayProvider);
            ref.invalidate(futureCustomerGroupsProvider);
            ref.invalidate(teamGroupByIdProvider);
          },
        ),
      ),
      child: Text("edit"),
    );
  }
}
