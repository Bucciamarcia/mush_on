import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/shared/dog_filter/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@riverpod
class FilterConditions extends _$FilterConditions {
  @override
  ConditionsGroup build() {
    return ConditionsGroup();
  }

  void setCondition(
      {required int position,
      ConditionSelection? conditionSelection,
      OperationSelection? operationSelection,
      dynamic filterSelection}) {
    List<ConditionSelectionElement> mutableConditions =
        List.from(state.conditions);
    ConditionSelectionElement toSet = mutableConditions.firstWhere(
        (condition) => condition.position == position,
        orElse: () => ConditionSelectionElement(position: position));
    if (conditionSelection != null) {
      toSet = toSet.copyWith(
          conditionSelection: conditionSelection, operationSelection: null);
    }
    if (operationSelection != null) {
      toSet = toSet.copyWith(operationSelection: operationSelection);
    }
    if (filterSelection != null && filterSelection != "") {
      toSet = toSet.copyWith(filterSelection: filterSelection);
    }

    mutableConditions.removeWhere((item) => item.position == position);

    state = state.copyWith(conditions: [...mutableConditions, toSet]);
  }

  /// Resets the conditions for when the page is reloaded
  void resetConditions() {
    state = state.copyWith(conditions: []);
  }
}

@freezed
abstract class ConditionsGroup with _$ConditionsGroup {
  const factory ConditionsGroup({
    @Default([]) List<ConditionSelectionElement> conditions,
    @Default(ConditionType.and) conditionType,
  }) = _ConditionsGroup;
}

@freezed
abstract class ConditionSelectionElement with _$ConditionSelectionElement {
  const factory ConditionSelectionElement(
      {required int position,
      ConditionSelection? conditionSelection,
      OperationSelection? operationSelection,
      dynamic filterSelection}) = _ConditionSelectionElement;
}
