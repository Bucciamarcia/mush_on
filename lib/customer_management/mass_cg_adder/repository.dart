import 'package:flutter/material.dart';
import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
import 'package:mush_on/customer_management/mass_cg_adder/riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';

class MassCgAdderRepository {
  /// The rule type for the mass add
  final SelectedRuleType ruleType;

  /// Only for week rule type
  final DaysOfWeekSelection? daysOfWeekSelected;

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
  Future<void> add() async {}
}
