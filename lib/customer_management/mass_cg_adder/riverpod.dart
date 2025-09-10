import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@riverpod
class SelectedRuleType extends _$SelectedRuleType {
  @override
  AddCgRuleType build() {
    return AddCgRuleType.weeklyOnDays;
  }

  void changeRuleType(AddCgRuleType newRuleType) {
    state = newRuleType;
  }
}

@riverpod
class DaysOfWeekSelected extends _$DaysOfWeekSelected {
  @override
  List<DaysOfWeekSelection> build() {
    return [];
  }

  /// Activates a day if inactive, deactivate if active.
  void flipday(DaysOfWeekSelection dayToFlip) {
    if (state.contains(dayToFlip)) {
      state = state.where((d) => d != dayToFlip).toList();
    } else {
      state = [dayToFlip, ...state];
    }
  }
}

@freezed
sealed class DateRangeSelectedValues with _$DateRangeSelectedValues {
  const factory DateRangeSelectedValues({
    DateTime? initialDay,
    DateTime? finalDay,
  }) = _DateRangeSelectedValues;
}

@riverpod
class DateRangeSelectedForWeekSelection
    extends _$DateRangeSelectedForWeekSelection {
  @override
  DateRangeSelectedValues? build() {
    return null;
  }

  void change(DateRangeSelectedValues? newValue) {
    state = newValue;
  }
}

@riverpod
class OnSelectedDaysSelected extends _$OnSelectedDaysSelected {
  @override
  List<DateTime> build() {
    return [];
  }

  void changeSelected(List<DateTime> newSelection) {
    state = newSelection;
  }
}

@riverpod
class MassCgEditorCgName extends _$MassCgEditorCgName {
  @override
  String build() {
    return "";
  }

  void change(String n) {
    state = n;
  }
}

@riverpod
class MassCgEditorCgTime extends _$MassCgEditorCgTime {
  @override
  TimeOfDay build() {
    return TimeOfDay.now();
  }

  void change(TimeOfDay newTime) {
    state = newTime;
  }
}

@riverpod
class MassCgEditorCgCapacity extends _$MassCgEditorCgCapacity {
  @override
  int? build() {
    return null;
  }

  void change(int? newCapacity) {
    state = newCapacity;
  }
}

@riverpod
class MassCgEditorTourType extends _$MassCgEditorTourType {
  @override
  TourType? build() {
    return null;
  }

  void change(TourType n) {
    state = n;
  }
}

@riverpod

/// Checks whether all the data has been correctly set and the mass CG can be added.
bool canAddCgs(Ref ref) {
  final ruletype = ref.watch(selectedRuleTypeProvider);

  switch (ruletype) {
    case AddCgRuleType.weeklyOnDays:
      {
        final daysOfWeekSelected = ref.watch(daysOfWeekSelectedProvider);
        if (daysOfWeekSelected.isEmpty) return false;

        final range = ref.watch(dateRangeSelectedForWeekSelectionProvider);
        if (range == null ||
            range.initialDay == null ||
            range.finalDay == null) {
          return false;
        }
        if (range.initialDay!.isAfter(range.finalDay!)) return false;
        break;
      }
    case AddCgRuleType.onSelectedDays:
      {
        final datesSelected = ref.watch(onSelectedDaysSelectedProvider);
        if (datesSelected.isEmpty) return false;
        break;
      }
  }

  if (ref.watch(massCgEditorCgNameProvider).isEmpty ||
      ref.watch(massCgEditorCgCapacityProvider) == null ||
      ref.watch(massCgEditorTourTypeProvider) == null) {
    return false;
  }
  return true;
}
