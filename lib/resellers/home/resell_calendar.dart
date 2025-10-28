import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/resellers/home/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ResellCalendar extends ConsumerWidget {
  const ResellCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = BasicLogger();
    final accountToResell = ref.watch(accountToResellProvider).value;
    if (accountToResell == null) return const SizedBox.shrink();
    final tourTypesAsync =
        ref.watch(tourTypesProvider(accountToResell.accountName));
    final visibleDates = ref.watch(visibleDatesProvider);
    final visibleCgs = ref
        .watch(customerGroupsByDateRangeProvider(visibleDates,
            account: accountToResell.accountName))
        .value;
    return tourTypesAsync.when(
        data: (tourTypes) {
          if (tourTypes.isEmpty) {
            return const Text("There are no tours available for this operator");
          }
          if (visibleCgs == null) {
            return const CircularProgressIndicator.adaptive();
          }
          return SfCalendar(
            showNavigationArrow: true,
            dataSource: BookingDataSource(ref: ref, source: visibleCgs),
            view: CalendarView.month,
            onViewChanged: (details) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref
                    .read(visibleDatesProvider.notifier)
                    .change(details.visibleDates);
              });
            },
          );
        },
        error: (e, s) {
          logger.error("Error loading tour types for resell calendar",
              error: e, stackTrace: s);
          return Text("Error loading tour types: $e");
        },
        loading: () => const CircularProgressIndicator.adaptive());
  }
}

class BookingDataSource extends CalendarDataSource<CustomerGroup> {
  final WidgetRef ref;
  BookingDataSource({required List<CustomerGroup> source, required this.ref}) {
    appointments = source;
  }
  @override
  String getSubject(int index) {
    List<Customer> customers = ref
            .watch(customersByCustomerGroupIdProvider(appointments![index].id))
            .value ??
        [];
    return appointments![index].name +
        " " +
        "${customers.length}/${appointments![index].maxCapacity}";
  }

  @override
  Color getColor(int index) {
    final cg = appointments![index];
    if (cg.tourTypeId != null) {
      final tourType = ref.watch(tourTypeByIdProvider(cg.tourTypeId!)).value;
      if (tourType?.backgroundColor != null) {
        return tourType!.backgroundColor;
      }
    }
    return Theme.of(ref.context).colorScheme.primary; // fallback
  }
}
