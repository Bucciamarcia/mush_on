import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/shared/dog_filter/enums.dart';

class DogFilterProvider extends ChangeNotifier {
  BasicLogger logger = BasicLogger();
  List<ConditionSelectionElement> conditions = [];
  ConditionType conditionType = ConditionType.and;

  DogFilterProvider();

  /// Creates or update a certain condition in the list
  void setCondition(
      {required int position,
      ConditionSelection? conditionSelection,
      OperationSelection? operationSelection,
      dynamic filterSelection}) {
    ConditionSelectionElement toSet = conditions.firstWhere(
        (condition) => condition.position == position,
        orElse: () => ConditionSelectionElement(position: position));
    if (conditionSelection != null) {
      toSet.conditionSelection = conditionSelection;
      toSet.operationSelection = null;
    }
    if (operationSelection != null) {
      toSet.operationSelection = operationSelection;
    }
    if (filterSelection != null && filterSelection != "") {
      toSet.filterSelection = filterSelection;
    }

    conditions.removeWhere((item) => item.position == position);
    conditions.add(toSet);
    logger.debug(
        "Condition: ${toSet.filterSelection.toString()} - ${toSet.operationSelection.toString()} - ${toSet.conditionSelection} - ${toSet.position}");
    notifyListeners();
  }

  /// Resets the conditions for when the page is reloaded
  void resetConditions() => conditions = [];
}

class ConditionSelectionElement {
  final int position;
  ConditionSelection? conditionSelection;
  OperationSelection? operationSelection;
  dynamic filterSelection;

  ConditionSelectionElement(
      {required this.position,
      this.conditionSelection,
      this.operationSelection,
      this.filterSelection});
}
