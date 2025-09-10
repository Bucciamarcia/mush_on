import 'package:flutter/material.dart';
import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
import 'package:mush_on/customer_management/mass_cg_adder/riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';

class MassCgAdderRepository {
  final logger = BasicLogger();

  /// The rule type for the mass add
  final AddCgRuleType ruleType;

  /// Only for week rule type
  final List<DaysOfWeekSelection>? daysOfWeekSelected;

  /// Only for week rule type
  final DateRangeSelectedValues? dateRangeSelection;

  /// Only for selected days rule type
  final List<DateTime>? onSelectedDaysSelected;
  final String cgName;
  final TimeOfDay time;
  final int maxCapacity;
  final TourType tourtype;

  MassCgAdderRepository({
    required this.ruleType,
    this.daysOfWeekSelected,
    this.dateRangeSelection,
    this.onSelectedDaysSelected,
    required this.cgName,
    required this.time,
    required this.maxCapacity,
    required this.tourtype,
  });

  /// Entrypoint. Given all the data in the the mass adder, add all the CGs in the db.
  Future<void> add() async {
    late List<DateTime> datesToAdd;
    switch (ruleType) {
      case AddCgRuleType.onSelectedDays:
        {
          try {
            datesToAdd = onSelectedDaysSelected!;
          } catch (e, s) {
            logger.error("Dates to add must not be null in type onSelectedDays",
                error: e, stackTrace: s);
            rethrow;
          }
        }
      case AddCgRuleType.weeklyOnDays:
        if (daysOfWeekSelected == null ||
            dateRangeSelection == null ||
            dateRangeSelection!.initialDay == null ||
            dateRangeSelection!.finalDay == null) {
          logger.error(
              "Days of week and date range must not be null in type weeklyOnDays");
          throw Exception(
              "Days of week and date range must not be null in type weeklyOnDays");
        }
        datesToAdd = _buildDatesToAddForWeekly();
    }
  }

  List<DateTime> _buildDatesToAddForWeekly() {
    List<DateTime> toReturn = [];
    List<int> weekdaysSelected =
        daysOfWeekSelected!.map((s) => s.weekday).toList();
    DateTime dateTicker = dateRangeSelection!.initialDay!;
    while (!dateTicker.isAfter(dateRangeSelection!.finalDay!)) {
      if (weekdaysSelected.contains(dateTicker.weekday)) {
        toReturn.add(dateTicker);
      }
      dateTicker = dateTicker.add(const Duration(days: 1));
    }
    return toReturn;
  }
}
