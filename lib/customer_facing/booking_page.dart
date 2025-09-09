import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_facing/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';

class BookingPage extends ConsumerStatefulWidget {
  final String? account;
  final String? tourId;
  const BookingPage({super.key, required this.tourId, required this.account});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.account == null || widget.tourId == null) {
      return const NoKennelOrTourIdErrorPage();
    }

    /// Info about the tour type that is being booked.
    TourType? tourType = ref
        .watch(
            tourTypeProvider(account: widget.account!, tourId: widget.tourId!))
        .value;

    /// All the customers that are already booked in this tour type.
    List<CustomerGroup> customerGroups = ref
            .watch(customerGroupsForTourProvider(
                account: widget.account!,
                tourTypeId: widget.tourId!,
                finalDate: DateTime(2026),
                intialDate: DateTime(2020)))
            .value ??
        [];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(tourType?.name ?? "No tour type"),
            ...customerGroups.map((cg) => Text(cg.datetime.toIso8601String()))
          ],
        ),
      ),
    );
  }
}

class NoKennelOrTourIdErrorPage extends StatelessWidget {
  const NoKennelOrTourIdErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Text("Error: kennel or tourId are empty")),
    );
  }
}
