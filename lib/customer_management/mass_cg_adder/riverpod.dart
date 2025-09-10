import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

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
      state = state.where((d) => d.name != dayToFlip.name).toList();
    } else {
      state = [dayToFlip, ...state];
    }
  }
}
