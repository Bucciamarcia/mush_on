import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';

enum ConditionSelection {
  name(type: String, allowedOperations: [
    OperationSelection.contains,
  ]),
  age(type: int, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.moreThan,
    OperationSelection.equalsNot,
    OperationSelection.lessThan
  ]),
  position(type: DogPositions, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.equalsNot
  ]),
  tag(type: Tag, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.equalsNot
  ]),
  sex(type: DogSex, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.equalsNot
  ]),
  customField(type: CustomFieldTemplate, allowedOperations: [
    OperationSelection.equals,
    OperationSelection.equalsNot,
    OperationSelection.moreThan,
    OperationSelection.lessThan,
    OperationSelection.contains
  ]);

  /// The type of the filter when this condition is used
  final Type type;

  /// The operations supported by this condition
  final List<OperationSelection> allowedOperations;
  const ConditionSelection(
      {required this.type, required this.allowedOperations});
}

/// A helper class that joins together the value and template of
/// the filtering by custom fields.
class FilterCustomFieldResults {
  final CustomFieldValue value;
  final CustomFieldTemplate template;

  FilterCustomFieldResults({required this.template, required this.value});
}

enum OperationSelection {
  equals(symbol: "equals"),
  contains(symbol: "contains"),
  equalsNot(symbol: "not equal"),
  moreThan(symbol: "more than"),
  lessThan(symbol: "less than");

  final String symbol;
  const OperationSelection({required this.symbol});
}

enum ConditionType {
  and(symbol: "and"),
  or(symbol: "or");

  final String symbol;
  const ConditionType({required this.symbol});
}
