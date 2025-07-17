import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/repository.dart';
import 'package:mush_on/riverpod.dart';

class ClientManagementMainScreen extends ConsumerWidget {
  const ClientManagementMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);
    return ElevatedButton(
      onPressed: () async => await customerRepo.addBooking(),
      child: Text("Add Booking"),
    );
  }
}
