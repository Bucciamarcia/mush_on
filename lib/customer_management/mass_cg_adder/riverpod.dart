import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
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
