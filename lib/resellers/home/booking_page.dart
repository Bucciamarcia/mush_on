import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/resellers/home/riverpod.dart';
import 'package:mush_on/resellers/reseller_template.dart';
import 'package:mush_on/services/error_handling.dart';

class BookingDetailsReseller extends ConsumerWidget {
  const BookingDetailsReseller({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCg = ref.watch(selectedCustomerGroupProvider);
    if (selectedCg == null) {
      return const ResellerError(
          message: "There is no selected customer group");
    }
    return ResellerTemplate(
        title: "Booking details",
        child: BookingDetailsResellerMain(cg: selectedCg));
  }
}

class BookingDetailsResellerMain extends ConsumerWidget {
  final CustomerGroup cg;
  const BookingDetailsResellerMain({super.key, required this.cg});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final bookingDataAsync = ref.watch(bookingDetailsDataFetchProvider);
    return bookingDataAsync.when(
        data: (bookingData) {
          if (bookingData.resellerUser == null) {
            logger.error("not logged in");
            return const Text("Not logged in");
          }
          if (bookingData.resellerData == null) {
            logger.error("no reseller data");
            return const Text("No reseller data present");
          }
          if (bookingData.resellerSettings == null) {
            logger.error("no reseller settings");
            return const Text(
                "The kennel hasn't specified any reseller settings");
          }
          if (bookingData.accountToResell == null) {
            logger.error("no account to resell");
            return const Text("There is no account to resell set");
          }
          return Column(
            children: [
              Text(cg.toString()),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Go back")),
            ],
          );
        },
        error: (e, s) {
          logger.error("Couldn't load data for reseller details",
              error: e, stackTrace: s);
          return ResellerError(
              message:
                  "Couldn't load the data: error occurred - ${e.toString()}");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
