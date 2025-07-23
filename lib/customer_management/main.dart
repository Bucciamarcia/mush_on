import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/repository.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

import 'alert_editors/booking.dart';

class ClientManagementMainScreen extends ConsumerWidget {
  static final logger = BasicLogger();
  const ClientManagementMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String account = ref.watch(accountProvider).value ?? "";
    final customerRepo = CustomerManagementRepository(account: account);
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) =>
              BookingEditorAlert(onBookingAdded: (newBooking) async {
            try {
              await customerRepo.setBooking(newBooking);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(confirmationSnackbar(
                    context, "Booking added successfully"));
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    errorSnackBar(context, "Couldn't add booking"));
              }
            }
          }),
        );
      },
      child: Text("Add Booking"),
    );
  }
}
