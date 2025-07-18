import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/repository.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

class ClientManagementMainScreen extends ConsumerWidget {
  const ClientManagementMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);
    return ElevatedButton(
      onPressed: () async {
        try {} catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBar(context, "Couldn't add the booking: $e"),
          );
        }
      },
      child: Text("Add Booking"),
    );
  }
}
