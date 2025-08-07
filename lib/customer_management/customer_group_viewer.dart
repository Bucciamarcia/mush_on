import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/page_template.dart';
import 'package:mush_on/services/error_handling.dart';

import '../create_team/riverpod.dart';
import '../riverpod.dart';
import 'alert_editors/customer_group.dart';
import 'repository.dart';
import 'riverpod.dart';

class CustomerGroupViewerScreen extends StatelessWidget {
  final String customerGroupId;
  const CustomerGroupViewerScreen({super.key, required this.customerGroupId});

  @override
  Widget build(BuildContext context) {
    return TemplateScreen(
      title: "View customer group",
      child: CustomerGroupViewer(customerGroupId: customerGroupId),
    );
  }
}

class CustomerGroupViewer extends ConsumerWidget {
  final String customerGroupId;
  const CustomerGroupViewer({super.key, required this.customerGroupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider).value ?? "";
    final customerGroupAsync = ref.watch(
      CustomerGroupByIdProvider(customerGroupId),
    );
    return customerGroupAsync.when(
      data: (customerGroup) {
        if (customerGroup == null) {
          BasicLogger().error("Couldn't load teamgroup: $customerGroupId");
          return Text("Couldn't load teamgroup: null");
        }
        final customerRepo = CustomerManagementRepository(account: account);
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                customerGroup.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => CustomerGroupEditorAlert(
                    onCustomerGroupDeleted: () => customerRepo
                        .deleteCustomerGroup(customerGroup.id)
                        .catchError(
                      (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            errorSnackBar(
                                context, "Failed to delete customer group."),
                          );
                        }
                      },
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
                child: Text("Edit Customer Group"),
              ),
            ],
          ),
        );
      },
      error: (e, s) {
        BasicLogger().error("Error loading customer group: $customerGroupId",
            error: e, stackTrace: s);
        return Center(child: Text("Error: couldn't load the customer group."));
      },
      loading: () => Center(
        child: SizedBox.square(
          dimension: 150,
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
