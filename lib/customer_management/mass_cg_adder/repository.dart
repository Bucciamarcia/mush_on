import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
import 'package:mush_on/customer_management/mass_cg_adder/riverpod.dart';
import 'package:mush_on/customer_management/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:uuid/uuid.dart';

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
  final TourType tourType;
  final String account;
  final db = FirebaseFirestore.instance;

  /// Maximum number of dates the user can add in batch, to guard against accidents.
  static const int maxDatesAllowed = 200;

  MassCgAdderRepository(
      {required this.ruleType,
      this.daysOfWeekSelected,
      this.dateRangeSelection,
      this.onSelectedDaysSelected,
      required this.cgName,
      required this.time,
      required this.maxCapacity,
      required this.tourType,
      required this.account});

  /// Entrypoint. Given all the data in the the mass adder, add all the CGs in the db.
  Future<void> add() async {
    List<DateTime> datesToAdd = _getDatesToAdd();
    if (datesToAdd.length > maxDatesAllowed) {
      throw TooManyDatesException(
          "Safety error. Too many dates added: ${datesToAdd.length}/$maxDatesAllowed");
    }
    final batch = db.batch();
    for (DateTime date in datesToAdd) {
      String id = const Uuid().v4();
      String path = "accounts/$account/data/bookingManager/customerGroups/$id";
      var doc = db.doc(path);
      CustomerGroup cg = CustomerGroup(
          id: id,
          datetime:
              DateTime(date.year, date.month, date.day, time.hour, time.minute),
          name: cgName,
          tourTypeId: tourType.id,
          maxCapacity: maxCapacity);
      batch.set(doc, cg.toJson());
    }
    try {
      await batch.commit();
    } catch (e, s) {
      logger.error("Error adding customer groups in batch",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  List<DateTime> _getDatesToAdd() {
    switch (ruleType) {
      case AddCgRuleType.onSelectedDays:
        {
          try {
            return onSelectedDaysSelected!;
          } catch (e, s) {
            logger.error("Dates to add must not be null in type onSelectedDays",
                error: e, stackTrace: s);
            rethrow;
          }
        }
      case AddCgRuleType.weeklyOnDays:
        {
          if (daysOfWeekSelected == null ||
              daysOfWeekSelected!.isEmpty ||
              dateRangeSelection == null ||
              dateRangeSelection!.initialDay == null ||
              dateRangeSelection!.finalDay == null) {
            logger.error(
                "Days of week and date range must not be null in type weeklyOnDays");
            throw Exception(
                "Days of week and date range must not be null in type weeklyOnDays");
          }
          return _buildDatesToAddForWeekly();
        }
    }
  }

  List<DateTime> _buildDatesToAddForWeekly() {
    final start = DateTime(
      dateRangeSelection!.initialDay!.year,
      dateRangeSelection!.initialDay!.month,
      dateRangeSelection!.initialDay!.day,
    );
    final end = DateTime(
      dateRangeSelection!.finalDay!.year,
      dateRangeSelection!.finalDay!.month,
      dateRangeSelection!.finalDay!.day,
    );

    final selectedWeekdays = daysOfWeekSelected!.map((s) => s.weekday).toSet();

    final toReturn = <DateTime>[];
    for (var d = start;
        !d.isAfter(end);
        d = DateTime(d.year, d.month, d.day + 1)) {
      if (selectedWeekdays.contains(d.weekday)) {
        toReturn.add(d);
      }
    }
    return toReturn;
  }
}

/// Custom error if the user added too many dates
class TooManyDatesException implements Exception {
  final String message;
  TooManyDatesException(this.message);
  @override
  String toString() => "TooManyDatesException: $message";
}
