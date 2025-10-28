import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/riverpod.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/resellers/home/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ResellCalendar extends ConsumerStatefulWidget {
  const ResellCalendar({super.key});

  @override
  ConsumerState<ResellCalendar> createState() => _ResellCalendarState();
}

class _ResellCalendarState extends ConsumerState<ResellCalendar> {
  late List<DateTime> visibleDates;
  @override
  void initState() {
    super.initState();
    visibleDates = [];
  }

  @override
  Widget build(BuildContext context) {
    final logger = BasicLogger();
    final accountToResell = ref.watch(accountToResellProvider).value;
    if (accountToResell == null) return const SizedBox.shrink();
    final tourTypes =
        ref.watch(tourTypesProvider(accountToResell.accountName)).value;
    final visibleCgs = ref
        .watch(customerGroupsByDateRangeProvider(visibleDates,
            account: accountToResell.accountName))
        .value;
    if (tourTypes?.isEmpty ?? true) {
      return const Text("There are no tours available for this operator");
    }
    if (visibleCgs == null) {
      return const CircularProgressIndicator.adaptive();
    }
    return SfCalendar(
      showNavigationArrow: true,
      dataSource: BookingDataSource(
          ref: ref, source: visibleCgs, account: accountToResell.accountName),
      view: CalendarView.month,
      onViewChanged: (details) {
        final newVisible = details.visibleDates;
        if (listEquals<DateTime>(visibleDates, newVisible)) {
          return; // No actual change; avoid redundant rebuilds
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            visibleDates = newVisible;
          });
        });
      },
    );
  }
}

class BookingDataSource extends CalendarDataSource<CustomerGroup> {
  final WidgetRef ref;
  final String account;
  BookingDataSource(
      {required List<CustomerGroup> source,
      required this.ref,
      required this.account}) {
    appointments = source;
  }
  @override
  String getSubject(int index) {
    List<Customer> customers = ref
            .watch(customersByCustomerGroupIdProvider(appointments![index].id,
                account: account))
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
      final tourType = ref
          .watch(tourTypeByIdProvider(cg.tourTypeId!, account: account))
          .value;
      if (tourType?.backgroundColor != null) {
        return tourType!.backgroundColor;
      }
    }
    return Theme.of(ref.context).colorScheme.primary; // fallback
  }
}
